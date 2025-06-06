-- First create the users table that all forms reference
-- CREATE TABLE users (
--     id CHAR(36) PRIMARY KEY,
--     username VARCHAR(50) NOT NULL UNIQUE,
--     email VARCHAR(255) NOT NULL UNIQUE,
--     password_hash VARCHAR(255) NOT NULL,
--     role ENUM('admin', 'field_agent', 'consultant', 'client') NOT NULL,
--     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
--     updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
--     deleted_at TIMESTAMP NULL
-- ) ENGINE=InnoDB;

-- Then create form_stage_a with proper UUID handling
CREATE TABLE form_stage_a (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    user_id CHAR(36) NOT NULL,
    project_type ENUM('federal', 'state', 'agency', 'community', 'individual') NOT NULL,
    agency_name VARCHAR(255),
    client_name VARCHAR(255) NOT NULL,
    client_phone VARCHAR(20) NOT NULL,
    client_email VARCHAR(255),
    state VARCHAR(100) NOT NULL,
    lga VARCHAR(100) NOT NULL,
    town VARCHAR(100) NOT NULL,
    street_address TEXT NOT NULL,
    latitude VARCHAR(50),
    longitude VARCHAR(50),
    consultant_name VARCHAR(255),
    consultant_phone VARCHAR(20),
    consultant_email VARCHAR(255),
    consultant_license VARCHAR(100),
    consultant_address TEXT,
    estimated_overburden VARCHAR(100),
    estimated_depth VARCHAR(100),
    estimated_fracture_depth VARCHAR(100),
    estimated_weathered_zone VARCHAR(100),
    curve_type VARCHAR(100),
    accessibility BOOLEAN,
    status ENUM('draft', 'completed') DEFAULT 'draft',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_stage_a_user (user_id),
    INDEX idx_stage_a_status (status),
    INDEX idx_stage_a_deleted (deleted_at)
) ENGINE=InnoDB;

-- Create form_stage_b with reference to stage_a
CREATE TABLE form_stage_b (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    form_stage_a_id CHAR(36) NOT NULL,
    user_id CHAR(36) NOT NULL,
    drilling_company VARCHAR(255) NOT NULL,
    drilling_license VARCHAR(100) NOT NULL,
    permit_no VARCHAR(100) NOT NULL,
    permit_issue_date DATE NOT NULL,
    actual_overburden VARCHAR(100) NOT NULL,
    fractured_zone VARCHAR(100) NOT NULL,
    weathered_zone VARCHAR(100) NOT NULL,
    depth_drilled VARCHAR(100) NOT NULL,
    drilled_diameter VARCHAR(100) NOT NULL,
    drilling_method ENUM('mud-drill', 'dthh', 'both') NOT NULL,
    rods JSON,
    casing_diameter VARCHAR(100),
    casing_type VARCHAR(100),
    casing_length VARCHAR(100),
    casing_count VARCHAR(100),
    gravel_packing_size VARCHAR(100),
    is_successful BOOLEAN NOT NULL,
    depth_installed VARCHAR(100),
    discharging_rate VARCHAR(100),
    water_cut BOOLEAN,
    water_cut_date DATE,
    water_cut_time TIME,
    static_water_level VARCHAR(100),
    status ENUM('draft', 'completed') DEFAULT 'draft',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    FOREIGN KEY (form_stage_a_id) REFERENCES form_stage_a(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_stage_b_stage_a (form_stage_a_id),
    INDEX idx_stage_b_user (user_id),
    INDEX idx_stage_b_status (status),
    INDEX idx_stage_b_deleted (deleted_at)
) ENGINE=InnoDB;

-- Create form_stage_c with reference to stage_b
CREATE TABLE form_stage_c (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    form_stage_b_id CHAR(36) NOT NULL,
    user_id CHAR(36) NOT NULL,
    project_id VARCHAR(100) NOT NULL,
    project_name VARCHAR(255) NOT NULL,
    water_type ENUM('Borehole', 'Well', 'Surface Water', 'Rainwater Tank', 'Other') NOT NULL,
    state VARCHAR(100) NOT NULL,
    lga VARCHAR(100) NOT NULL,
    community VARCHAR(100) NOT NULL,
    gps_coordinates VARCHAR(100) NOT NULL,
    tester_full_name VARCHAR(255) NOT NULL,
    tester_role ENUM('Hydrogeologist', 'Engineer', 'Field Officer', 'Lab Technician') NOT NULL,
    tester_license_number VARCHAR(100) NOT NULL,
    tester_phone_number VARCHAR(20) NOT NULL,
    tester_email_address VARCHAR(255),
    date_of_sample_collection DATE NOT NULL,
    time_of_collection TIME NOT NULL,
    collected_by VARCHAR(255) NOT NULL,
    weather_conditions ENUM('Sunny', 'Rainy', 'Cloudy', 'Other') NOT NULL,
    sample_container_type ENUM('Sterile Plastic', 'Glass', 'Other') NOT NULL,
    observations TEXT,
    parameters JSON NOT NULL,
    lab_test_certificate_path VARCHAR(255),
    raw_lab_sheet_path VARCHAR(255),
    sampling_point_photos_paths JSON,
    is_safe ENUM('Yes', 'No', 'Requires Treatment') NOT NULL,
    next_step ENUM('Approve', 'Re-Test', 'Recommend Treatment', 'Abandon Source') NOT NULL,
    comments TEXT,
    signature_data TEXT NOT NULL,
    submission_date DATE NOT NULL,
    status ENUM('draft', 'submitted', 'approved', 'rejected') DEFAULT 'draft',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    FOREIGN KEY (form_stage_b_id) REFERENCES form_stage_b(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_stage_c_stage_b (form_stage_b_id),
    INDEX idx_stage_c_user (user_id),
    INDEX idx_stage_c_status (status),
    INDEX idx_stage_c_deleted (deleted_at)
) ENGINE=InnoDB;