/*
 * File   : $Source: /alkacon/cvs/opencms/src/org/opencms/db/CmsCacheKey.java,v $
 * Date   : $Date: 2004/06/14 12:19:33 $
 * Version: $Revision: 1.9 $
 *
 * This library is part of OpenCms -
 * the Open Source Content Mananagement System
 *
 * Copyright (C) 2002 - 2003 Alkacon Software (http://www.alkacon.com)
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * For further information about Alkacon Software, please see the
 * company website: http://www.alkacon.com
 *
 * For further information about OpenCms, please see the
 * project website: http://www.opencms.org
 * 
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */
package org.opencms.db;


import org.opencms.file.CmsRequestContext;
import org.opencms.file.CmsResource;
import org.opencms.file.CmsUser;
import org.opencms.security.CmsPermissionSet;

/**
 * Generates the cache keys for the user and permission caches.<p>
 * 
 * @version $Revision: 1.9 $ $Date: 2004/06/14 12:19:33 $
 * @author Carsten Weinholz (c.weinholz@alkacon.com)
 */
public class CmsCacheKey implements I_CmsCacheKey {
    
    /** Cache key for a list of sub-resources (files and folders) of a folder. */
    public static final String C_CACHE_KEY_SUBALL = "_all_";
    
    /** Cache key for a list of sub-files of a folder. */
    public static final String C_CACHE_KEY_SUBFILES = "_files_";
    
    /** Cache key for a list of sub-folders of a folder. */
    public static final String C_CACHE_KEY_SUBFOLDERS = "_folders_";

    /**
     * Constructor to create a new instance of CmsCacheKey.<p>
     */
    public CmsCacheKey() {
        // empty
    }
    
    /**
     * @see org.opencms.db.I_CmsCacheKey#getCacheKeyForUserPermissions(java.lang.String, org.opencms.file.CmsRequestContext, org.opencms.file.CmsResource, org.opencms.security.CmsPermissionSet)
     */
    public String getCacheKeyForUserPermissions(String prefix, CmsRequestContext context, CmsResource resource, CmsPermissionSet requiredPermissions) {
        
        StringBuffer cacheBuffer = new StringBuffer(64);
        cacheBuffer.append(prefix);
        cacheBuffer.append('_');        
        cacheBuffer.append(context.currentUser().getName());
        cacheBuffer.append(context.currentProject().isOnlineProject()?"_0_":"_1_");
        cacheBuffer.append(requiredPermissions.getPermissionString());
        cacheBuffer.append('_');
        cacheBuffer.append(resource.getStructureId().toString());
        return cacheBuffer.toString();
    }
    
    /**
     * @see org.opencms.db.I_CmsCacheKey#getCacheKeyForUserGroups(java.lang.String, org.opencms.file.CmsRequestContext, org.opencms.file.CmsUser)
     */
    public String getCacheKeyForUserGroups (String prefix, CmsRequestContext context, CmsUser user) {
        
        StringBuffer cacheBuffer = new StringBuffer(64);
        cacheBuffer.append(prefix);
        cacheBuffer.append('_');
        cacheBuffer.append(user.getName());
        return cacheBuffer.toString();       
    }
}