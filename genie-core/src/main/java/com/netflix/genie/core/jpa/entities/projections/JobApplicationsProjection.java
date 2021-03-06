/*
 *
 *  Copyright 2017 Netflix, Inc.
 *
 *     Licensed under the Apache License, Version 2.0 (the "License");
 *     you may not use this file except in compliance with the License.
 *     You may obtain a copy of the License at
 *
 *         http://www.apache.org/licenses/LICENSE-2.0
 *
 *     Unless required by applicable law or agreed to in writing, software
 *     distributed under the License is distributed on an "AS IS" BASIS,
 *     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *     See the License for the specific language governing permissions and
 *     limitations under the License.
 *
 */
package com.netflix.genie.core.jpa.entities.projections;

import com.netflix.genie.core.jpa.entities.ApplicationEntity;

import java.util.List;

/**
 * Projection to return just the applications associated with a given job.
 *
 * @author tgianos
 * @since 3.3.0
 */
public interface JobApplicationsProjection {

    /**
     * Get the applications associated with a job.
     *
     * @return The applications associated with a job in desired setup order
     */
    List<ApplicationEntity> getApplications();
}
