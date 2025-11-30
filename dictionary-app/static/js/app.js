// State
let darkMode = false;
let isLoading = false;

// Elements
const darkModeToggle = document.getElementById('darkModeToggle');
const moonIcon = document.getElementById('moonIcon');
const sunIcon = document.getElementById('sunIcon');
const englishInput = document.getElementById('englishInput');
const languageSelect = document.getElementById('languageSelect');
const translateBtn = document.getElementById('translateBtn');
const btnText = document.getElementById('btnText');
const translationOutput = document.getElementById('translationOutput');
const errorMessage = document.getElementById('errorMessage');

// Dark mode toggle
darkModeToggle.addEventListener('click', () => {
    darkMode = !darkMode;
    document.body.classList.toggle('dark-mode');

    if (darkMode) {
        moonIcon.classList.add('hidden');
        sunIcon.classList.remove('hidden');
    } else {
        moonIcon.classList.remove('hidden');
        sunIcon.classList.add('hidden');
    }
});

// Translate function
async function translate() {
    const text = englishInput.value.trim();
    const targetLanguage = languageSelect.value;

    if (!text) return;

    isLoading = true;
    translateBtn.disabled = true;
    btnText.textContent = 'Translating...';
    errorMessage.classList.add('hidden');
    translationOutput.textContent = 'Translation will appear here...';
    translationOutput.classList.remove('filled');
    translationOutput.classList.add('empty');

    try {
        const response = await fetch('/api/translate', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                text: text,
                target_language: targetLanguage
            })
        });

        const data = await response.json();

        if (!response.ok) {
            throw new Error(data.detail || 'Translation failed');
        }

        translationOutput.textContent = data.translation;
        translationOutput.classList.remove('empty');
        translationOutput.classList.add('filled', 'text-lg');
    } catch (error) {
        errorMessage.textContent = error.message || 'Translation failed. Please try again.';
        errorMessage.classList.remove('hidden');
        console.error('Translation error:', error);
    } finally {
        isLoading = false;
        translateBtn.disabled = false;
        btnText.textContent = 'Translate';
    }
}

// Event listeners
translateBtn.addEventListener('click', translate);

englishInput.addEventListener('keypress', (e) => {
    if (e.key === 'Enter') {
        translate();
    }
});

languageSelect.addEventListener('change', () => {
    translationOutput.textContent = 'Translation will appear here...';
    translationOutput.classList.remove('filled');
    translationOutput.classList.add('empty');
    errorMessage.classList.add('hidden');
});

// Update button state based on input
englishInput.addEventListener('input', () => {
    translateBtn.disabled = !englishInput.value.trim() || isLoading;
});

// Initial state
translateBtn.disabled = true;
