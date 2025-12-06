const { useState, useEffect } = React;

function App() {
  const [word, setWord] = useState('');
  const [context, setContext] = useState('');
  const [translation, setTranslation] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [isDarkMode, setIsDarkMode] = useState(true);

  useEffect(() => {
    const savedTheme = localStorage.getItem('theme');
    if (savedTheme === 'light') {
      setIsDarkMode(false);
      document.body.classList.add('light-mode');
    }
  }, []);

  const toggleTheme = () => {
    const newMode = !isDarkMode;
    setIsDarkMode(newMode);

    if (newMode) {
      document.body.classList.remove('light-mode');
      localStorage.setItem('theme', 'dark');
    } else {
      document.body.classList.add('light-mode');
      localStorage.setItem('theme', 'light');
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();

    if (!word.trim()) return;

    setError('');
    setLoading(true);
    setTranslation('');

    try {
      const response = await fetch('/api/translate', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          text: word.trim(),
          source_lang: 'en',
          target_lang: 'so',
          context: context.trim(),
        }),
      });

      const data = await response.json();

      if (response.ok) {
        setTranslation(data.translation);
      } else {
        // Handle validation errors from FastAPI
        let errorMessage = 'Translation failed';
        if (data.detail) {
          if (Array.isArray(data.detail)) {
            errorMessage = data.detail.map(err => err.msg).join(', ');
          } else if (typeof data.detail === 'string') {
            errorMessage = data.detail;
          }
        }
        throw new Error(errorMessage);
      }
    } catch (err) {
      setError(err.message || 'Failed to translate. Please try again.');
      setTranslation('');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="container">
      <div className="theme-toggle" onClick={toggleTheme} title="Toggle theme">
        <span>{isDarkMode ? '☀️' : '🌙'}</span>
      </div>

      <div className="header">
        <div className="header-icon">📖</div>
        <h1>English-Somali Dictionary</h1>
      </div>

      {error && (
        <div className="error">{error}</div>
      )}

      <form onSubmit={handleSubmit}>
        <div className="form-group">
          <label htmlFor="word">English Word or Phrase</label>
          <input
            type="text"
            id="word"
            value={word}
            onChange={(e) => setWord(e.target.value)}
            placeholder="Enter an English word or phrase..."
            required
            autoComplete="off"
          />
        </div>

        <div className="form-group">
          <label htmlFor="context">Context (Optional)</label>
          <input
            type="text"
            id="context"
            value={context}
            onChange={(e) => setContext(e.target.value)}
            placeholder="Add context for better translation..."
            autoComplete="off"
          />
        </div>

        <button type="submit" disabled={loading}>
          {loading ? (
            <>
              <span className="loading"></span>
              Translating...
            </>
          ) : (
            'Translate'
          )}
        </button>

        <div className="form-group">
          <label>Translation</label>
          <div className={`translation-result ${!translation ? 'empty' : ''}`}>
            {loading ? 'Translating...' : translation || 'Translation will appear here...'}
          </div>
        </div>
      </form>

      <div className="footer">
        Powered by AWS Bedrock and Claude
      </div>
    </div>
  );
}

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(<App />);
