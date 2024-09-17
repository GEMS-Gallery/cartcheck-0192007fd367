import { backend } from 'declarations/backend';

document.addEventListener('DOMContentLoaded', async () => {
    const itemInput = document.getElementById('item-input');
    const addButton = document.getElementById('add-button');
    const shoppingList = document.getElementById('shopping-list');

    async function loadItems() {
        const items = await backend.getItems();
        shoppingList.innerHTML = '';
        items.forEach(item => {
            const li = createItemElement(item);
            shoppingList.appendChild(li);
        });
    }

    function createItemElement(item) {
        const li = document.createElement('li');
        li.className = `shopping-item ${item.completed ? 'completed' : ''}`;
        li.innerHTML = `
            <button class="complete-btn"><i class="fas fa-check"></i></button>
            <span>${item.text}</span>
            <button class="delete-btn"><i class="fas fa-trash"></i></button>
        `;

        const completeBtn = li.querySelector('.complete-btn');
        completeBtn.addEventListener('click', async () => {
            await backend.toggleCompleted(item.id);
            await loadItems();
        });

        const deleteBtn = li.querySelector('.delete-btn');
        deleteBtn.addEventListener('click', async () => {
            await backend.deleteItem(item.id);
            await loadItems();
        });

        return li;
    }

    addButton.addEventListener('click', async () => {
        const text = itemInput.value.trim();
        if (text) {
            await backend.addItem(text);
            itemInput.value = '';
            await loadItems();
        }
    });

    itemInput.addEventListener('keypress', async (e) => {
        if (e.key === 'Enter') {
            const text = itemInput.value.trim();
            if (text) {
                await backend.addItem(text);
                itemInput.value = '';
                await loadItems();
            }
        }
    });

    await loadItems();
});
