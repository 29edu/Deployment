import { useState, useEffect } from "react";
import "./App.css";

const API_URL = import.meta.env.VITE_API_URL || "";

function App() {
  const [tasks, setTasks] = useState([]);
  const [newTask, setNewTask] = useState("");
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [apiInfo, setApiInfo] = useState(null);

  useEffect(() => {
    fetchApiInfo();
    fetchTasks();
  }, []);

  const fetchApiInfo = async () => {
    try {
      const response = await fetch(`${API_URL}/`);
      const data = await response.json();
      setApiInfo(data);
    } catch (err) {
      console.error("Failed to fetch API info:", err);
    }
  };

  const fetchTasks = async () => {
    try {
      setLoading(true);
      const response = await fetch(`${API_URL}/api/tasks`);
      if (!response.ok) throw new Error("Failed to fetch tasks");
      const data = await response.json();
      setTasks(data);
      setError(null);
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  const addTask = async (e) => {
    e.preventDefault();
    if (!newTask.trim()) return;

    try {
      const response = await fetch(`${API_URL}/api/tasks`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ title: newTask }),
      });
      if (!response.ok) throw new Error("Failed to add task");
      const task = await response.json();
      setTasks([...tasks, task]);
      setNewTask("");
    } catch (err) {
      setError(err.message);
    }
  };

  const toggleTask = async (id) => {
    const task = tasks.find((t) => t.id === id);
    try {
      const response = await fetch(`${API_URL}/api/tasks/${id}`, {
        method: "PUT",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ completed: !task.completed }),
      });
      if (!response.ok) throw new Error("Failed to update task");
      const updatedTask = await response.json();
      setTasks(tasks.map((t) => (t.id === id ? updatedTask : t)));
    } catch (err) {
      setError(err.message);
    }
  };

  const deleteTask = async (id) => {
    try {
      const response = await fetch(`${API_URL}/api/tasks/${id}`, {
        method: "DELETE",
      });
      if (!response.ok) throw new Error("Failed to delete task");
      setTasks(tasks.filter((t) => t.id !== id));
    } catch (err) {
      setError(err.message);
    }
  };

  return (
    <div className="app">
      <header className="app-header">
        <h1>🚀 Fullstack DevOps Deployment</h1>
        {apiInfo && (
          <p className="api-info">
            {apiInfo.message} - v{apiInfo.version}
          </p>
        )}
      </header>

      <main className="container">
        <div className="task-form">
          <h2>Task Manager</h2>
          <form onSubmit={addTask}>
            <input
              type="text"
              value={newTask}
              onChange={(e) => setNewTask(e.target.value)}
              placeholder="Enter a new task..."
              className="task-input"
            />
            <button type="submit" className="btn btn-primary">
              Add Task
            </button>
          </form>
        </div>

        {error && <div className="error-message">⚠️ Error: {error}</div>}

        {loading ? (
          <div className="loading">Loading tasks...</div>
        ) : (
          <div className="task-list">
            {tasks.length === 0 ? (
              <p className="no-tasks">No tasks yet. Add one above!</p>
            ) : (
              tasks.map((task) => (
                <div
                  key={task.id}
                  className={`task-item ${task.completed ? "completed" : ""}`}
                >
                  <input
                    type="checkbox"
                    checked={task.completed}
                    onChange={() => toggleTask(task.id)}
                    className="task-checkbox"
                  />
                  <span className="task-title">{task.title}</span>
                  <button
                    onClick={() => deleteTask(task.id)}
                    className="btn btn-danger"
                  >
                    Delete
                  </button>
                </div>
              ))
            )}
          </div>
        )}
      </main>

      <footer className="app-footer">
        <p>Powered by React + Express + Docker + Kubernetes</p>
      </footer>
    </div>
  );
}

export default App;
