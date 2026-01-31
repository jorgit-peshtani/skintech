import React, { useState, useEffect } from 'react';
import { usersAPI } from '../services/api';
import './Users.css';

function Users() {
    const [users, setUsers] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState('');
    const [searchTerm, setSearchTerm] = useState('');
    const [filterActive, setFilterActive] = useState('all');
    const [showModal, setShowModal] = useState(false);
    const [modalMode, setModalMode] = useState('add'); // 'add' or 'edit'
    const [selectedUser, setSelectedUser] = useState(null);
    const [formData, setFormData] = useState({
        email: '',
        username: '',
        password: '',
        is_admin: false,
        is_active: true
    });

    useEffect(() => {
        loadUsers();
    }, []);

    const loadUsers = async () => {
        try {
            setLoading(users.length === 0); // Only show loading on first load
            const response = await usersAPI.getAll();
            setUsers(response.data);
            setError('');
        } catch (err) {
            console.error('Failed to load users:', err);
            setError('Failed to load users');
        } finally {
            setLoading(false);
        }
    };

    const handleToggleStatus = async (userId) => {
        try {
            await usersAPI.toggleStatus(userId);
            loadUsers();
        } catch (err) {
            console.error('Failed to toggle user status:', err);
            alert('Failed to update user status');
        }
    };

    const handleAddUser = () => {
        setModalMode('add');
        setSelectedUser(null);
        setFormData({
            email: '',
            username: '',
            password: '',
            is_admin: false,
            is_active: true
        });
        setShowModal(true);
    };

    const handleEditUser = (user) => {
        setModalMode('edit');
        setSelectedUser(user);
        setFormData({
            email: user.email,
            username: user.username,
            password: '',
            is_admin: user.is_admin,
            is_active: user.is_active
        });
        setShowModal(true);
    };

    const handleDeleteUser = async (userId, username) => {
        if (!confirm(`Are you sure you want to delete user "${username}"? This action cannot be undone.`)) {
            return;
        }

        try {
            await usersAPI.delete(userId);
            // alert('User deleted successfully'); // Removed to prevent focus issues
            loadUsers();
        } catch (err) {
            console.error('Failed to delete user:', err);
            alert(err.response?.data?.error || 'Failed to delete user');
        }
    };

    const handleSubmit = async (e) => {
        e.preventDefault();

        try {
            if (modalMode === 'add') {
                await usersAPI.create(formData);
            } else {
                // For edit, only send password if it's not empty
                const updateData = { ...formData };
                if (!updateData.password) {
                    delete updateData.password;
                }
                await usersAPI.update(selectedUser.id, updateData);
            }
            setShowModal(false);
            loadUsers();
        } catch (err) {
            console.error('Failed to save user:', err);
            alert(err.response?.data?.error || 'Failed to save user');
        }
    };

    const filteredUsers = users.filter(user => {
        const matchesSearch = user.email.toLowerCase().includes(searchTerm.toLowerCase()) ||
            user.username.toLowerCase().includes(searchTerm.toLowerCase());

        if (filterActive === 'all') return matchesSearch;
        if (filterActive === 'active') return matchesSearch && user.is_active;
        if (filterActive === 'inactive') return matchesSearch && !user.is_active;
        return matchesSearch;
    });

    if (loading) {
        return (
            <div className="users-loading">
                <div className="spinner"></div>
                <p>Loading users...</p>
            </div>
        );
    }

    if (error) {
        return (
            <div className="users-error">
                <p>{error}</p>
                <button onClick={loadUsers}>Retry</button>
            </div>
        );
    }

    return (
        <div className="users-page">
            <div className="users-header">
                <div>
                    <h1>User Management</h1>
                    <p className="users-subtitle">Manage all registered users • Click 🔄 to refresh</p>
                </div>
                <div className="header-actions">
                    <button className="refresh-btn" onClick={() => loadUsers()} title="Refresh">
                        🔄
                    </button>
                    <button className="add-user-btn" onClick={handleAddUser}>
                        ➕ Add New User
                    </button>
                </div>
            </div>

            <div className="users-controls">
                <input
                    type="text"
                    className="search-input"
                    placeholder="Search by email or username..."
                    value={searchTerm}
                    onChange={(e) => setSearchTerm(e.target.value)}
                />

                <div className="filter-buttons">
                    <button
                        className={`filter-btn ${filterActive === 'all' ? 'active' : ''}`}
                        onClick={() => setFilterActive('all')}
                    >
                        All ({users.length})
                    </button>
                    <button
                        className={`filter-btn ${filterActive === 'active' ? 'active' : ''}`}
                        onClick={() => setFilterActive('active')}
                    >
                        Active ({users.filter(u => u.is_active).length})
                    </button>
                    <button
                        className={`filter-btn ${filterActive === 'inactive' ? 'active' : ''}`}
                        onClick={() => setFilterActive('inactive')}
                    >
                        Inactive ({users.filter(u => !u.is_active).length})
                    </button>
                </div>
            </div>

            <div className="users-table-container">
                <table className="users-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Username</th>
                            <th>Email</th>
                            <th>Role</th>
                            <th>Created</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        {filteredUsers.map(user => (
                            <tr key={user.id}>
                                <td>#{user.id}</td>
                                <td className="user-name">
                                    <div className="user-avatar">{user.username[0].toUpperCase()}</div>
                                    {user.username}
                                </td>
                                <td>{user.email}</td>
                                <td>
                                    <span className={`role-badge ${user.is_admin ? 'admin' : 'user'}`}>
                                        {user.is_admin ? 'Admin' : 'User'}
                                    </span>
                                </td>
                                <td>{new Date(user.created_at).toLocaleDateString()}</td>
                                <td>
                                    <span className={`status-badge ${user.is_active ? 'active' : 'inactive'}`}>
                                        {user.is_active ? 'Active' : 'Inactive'}
                                    </span>
                                </td>
                                <td className="action-buttons">
                                    <button
                                        className="action-btn edit"
                                        onClick={() => handleEditUser(user)}
                                        title="Edit user"
                                    >
                                        ✏️
                                    </button>
                                    <button
                                        className={`action-btn ${user.is_active ? 'deactivate' : 'activate'}`}
                                        onClick={() => handleToggleStatus(user.id)}
                                        title={user.is_active ? 'Deactivate' : 'Activate'}
                                    >
                                        {user.is_active ? '🚫' : '✅'}
                                    </button>
                                    <button
                                        className="action-btn delete"
                                        onClick={() => handleDeleteUser(user.id, user.username)}
                                        title="Delete user"
                                    >
                                        🗑️
                                    </button>
                                </td>
                            </tr>
                        ))}
                    </tbody>
                </table>

                {filteredUsers.length === 0 && (
                    <div className="no-results">
                        <p>No users found</p>
                    </div>
                )}
            </div>

            {/* User Modal */}
            {showModal && (
                <div className="modal-overlay" onClick={() => setShowModal(false)}>
                    <div className="modal-content" onClick={(e) => e.stopPropagation()}>
                        <div className="modal-header">
                            <h2>{modalMode === 'add' ? 'Add New User' : 'Edit User'}</h2>
                            <button className="modal-close" onClick={() => setShowModal(false)}>✕</button>
                        </div>
                        <form onSubmit={handleSubmit}>
                            <div className="form-group">
                                <label>Email *</label>
                                <input
                                    type="email"
                                    required
                                    value={formData.email}
                                    onChange={(e) => setFormData({ ...formData, email: e.target.value })}
                                />
                            </div>
                            <div className="form-group">
                                <label>Username *</label>
                                <input
                                    type="text"
                                    required
                                    value={formData.username}
                                    onChange={(e) => setFormData({ ...formData, username: e.target.value })}
                                />
                            </div>
                            <div className="form-group">
                                <label>Password {modalMode === 'edit' && '(leave blank to keep current)'}</label>
                                <input
                                    type="password"
                                    required={modalMode === 'add'}
                                    value={formData.password}
                                    onChange={(e) => setFormData({ ...formData, password: e.target.value })}
                                />
                            </div>
                            <div className="form-row">
                                <div className="form-group checkbox">
                                    <label>
                                        <input
                                            type="checkbox"
                                            checked={formData.is_admin}
                                            onChange={(e) => setFormData({ ...formData, is_admin: e.target.checked })}
                                        />
                                        Admin Role
                                    </label>
                                </div>
                                <div className="form-group checkbox">
                                    <label>
                                        <input
                                            type="checkbox"
                                            checked={formData.is_active}
                                            onChange={(e) => setFormData({ ...formData, is_active: e.target.checked })}
                                        />
                                        Active
                                    </label>
                                </div>
                            </div>
                            <div className="modal-actions">
                                <button type="button" className="btn-cancel" onClick={() => setShowModal(false)}>
                                    Cancel
                                </button>
                                <button type="submit" className="btn-save">
                                    {modalMode === 'add' ? 'Create User' : 'Update User'}
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            )}
        </div>
    );
}

export default Users;
