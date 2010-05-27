/*
 * File   : $Source: /alkacon/cvs/opencms/src-modules/org/opencms/ade/sitemap/Attic/CmsSitemapService.java,v $
 * Date   : $Date: 2010/05/27 06:52:03 $
 * Version: $Revision: 1.21 $
 *
 * This library is part of OpenCms -
 * the Open Source Content Management System
 *
 * Copyright (C) 2002 - 2009 Alkacon Software (http://www.alkacon.com)
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

package org.opencms.ade.sitemap;

import org.opencms.ade.sitemap.shared.CmsClientSitemapEntry;
import org.opencms.ade.sitemap.shared.CmsSitemapData;
import org.opencms.ade.sitemap.shared.CmsSitemapTemplate;
import org.opencms.ade.sitemap.shared.rpc.I_CmsSitemapService;
import org.opencms.file.CmsObject;
import org.opencms.file.CmsProperty;
import org.opencms.file.CmsPropertyDefinition;
import org.opencms.file.CmsResource;
import org.opencms.file.CmsResourceFilter;
import org.opencms.file.CmsVfsResourceNotFoundException;
import org.opencms.file.history.CmsHistoryResourceHandler;
import org.opencms.file.types.CmsResourceTypeJsp;
import org.opencms.file.types.CmsResourceTypeXmlContainerPage;
import org.opencms.flex.CmsFlexController;
import org.opencms.gwt.CmsGwtService;
import org.opencms.gwt.CmsRpcException;
import org.opencms.main.CmsException;
import org.opencms.main.OpenCms;
import org.opencms.util.CmsStringUtil;
import org.opencms.workplace.CmsWorkplace;
import org.opencms.workplace.explorer.CmsResourceUtil;
import org.opencms.xml.content.CmsXmlContentPropertyHelper;
import org.opencms.xml.sitemap.CmsSitemapEntry;
import org.opencms.xml.sitemap.CmsSitemapManager;
import org.opencms.xml.sitemap.CmsXmlSitemap;
import org.opencms.xml.sitemap.CmsXmlSitemapFactory;
import org.opencms.xml.sitemap.I_CmsSitemapChange;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

/**
 * Handles all RPC services related to the sitemap.<p>
 * 
 * @author Michael Moossen
 * 
 * @version $Revision: 1.21 $ 
 * 
 * @since 8.0.0
 * 
 * @see org.opencms.ade.sitemap.CmsSitemapService
 * @see org.opencms.ade.sitemap.shared.rpc.I_CmsSitemapService
 * @see org.opencms.ade.sitemap.shared.rpc.I_CmsSitemapServiceAsync
 */
public class CmsSitemapService extends CmsGwtService implements I_CmsSitemapService {

    /** Serialization uid. */
    private static final long serialVersionUID = -7136544324371767330L;

    /** Session attribute name constant. */
    private static final String SESSION_ATTR_ADE_SITEMAP_RECENT_LIST_CACHE = "__OCMS_ADE_SITEMAP_RECENT_LIST_CACHE__";

    /**
     * Returns a new configured service instance.<p>
     * 
     * @param request the current request
     * 
     * @return a new service instance
     */
    public static CmsSitemapService newInstance(HttpServletRequest request) {

        CmsSitemapService srv = new CmsSitemapService();
        srv.setCms(CmsFlexController.getCmsObject(request));
        srv.setRequest(request);
        return srv;
    }

    /**
     * @see org.opencms.ade.sitemap.shared.rpc.I_CmsSitemapService#createSubsitemap(java.lang.String, java.lang.String)
     */
    public String createSubsitemap(String sitemapUri, String path) {

        return null;
    }

    /**
     * @see org.opencms.ade.sitemap.shared.rpc.I_CmsSitemapService#exit(java.util.List)
     */
    public void exit(List<CmsClientSitemapEntry> recentList) throws CmsRpcException {

        try {
            if (recentList != null) {
                setRecentList(recentList);
            }
        } catch (Throwable e) {
            error(e);
        }
    }

    /**
     * @see org.opencms.ade.sitemap.shared.rpc.I_CmsSitemapService#getChildren(java.lang.String)
     */
    public List<CmsClientSitemapEntry> getChildren(String root) throws CmsRpcException {

        List<CmsClientSitemapEntry> children = null;
        try {
            children = getChildren(root, 1);
        } catch (Throwable e) {
            error(e);
        }
        return children;
    }

    /**
     * @see org.opencms.ade.sitemap.shared.rpc.I_CmsSitemapService#getEntry(String)
     */
    public CmsClientSitemapEntry getEntry(String root) throws CmsRpcException {

        CmsClientSitemapEntry result = null;
        try {
            result = toClientEntry(OpenCms.getSitemapManager().getEntryForUri(getCmsObject(), root));
        } catch (Throwable e) {
            error(e);
        }
        return result;
    }

    /**
     * Returns the available templates.<p>
     * 
     * @return the available templates
     * 
     * @throws CmsRpcException if something goes wrong
     */
    public Map<String, CmsSitemapTemplate> getTemplates() throws CmsRpcException {

        Map<String, CmsSitemapTemplate> result = new HashMap<String, CmsSitemapTemplate>();
        CmsObject cms = getCmsObject();
        try {
            // find current site templates
            int templateId = OpenCms.getResourceManager().getResourceType(
                CmsResourceTypeJsp.getContainerPageTemplateTypeName()).getTypeId();
            List<CmsResource> templates = cms.readResources(
                "/",
                CmsResourceFilter.ONLY_VISIBLE_NO_DELETED.addRequireType(templateId),
                true);
            if (CmsStringUtil.isNotEmptyOrWhitespaceOnly(cms.getRequestContext().getSiteRoot())) {
                // if not in the root site, also add template under /system/
                templates.addAll(cms.readResources(
                    CmsWorkplace.VFS_PATH_SYSTEM,
                    CmsResourceFilter.ONLY_VISIBLE_NO_DELETED.addRequireType(templateId),
                    true));
            }
            // convert resources to template beans
            for (CmsResource template : templates) {
                try {
                    CmsSitemapTemplate templateBean = getTemplateBean(cms, template);
                    result.put(templateBean.getSitePath(), templateBean);
                } catch (CmsException e) {
                    // should never happen
                    log(e.getLocalizedMessage(), e);
                }
            }
        } catch (Throwable e) {
            error(e);
        }
        return result;
    }

    /**
     * @see org.opencms.ade.sitemap.shared.rpc.I_CmsSitemapService#mergeSubsitemap(java.lang.String, java.lang.String)
     */
    public void mergeSubsitemap(String sitemapUri, String path) {

        // TODO: 
    }

    /**
     * @see org.opencms.ade.sitemap.shared.rpc.I_CmsSitemapService#prefetch(java.lang.String)
     */
    public CmsSitemapData prefetch(String sitemapUri) throws CmsRpcException {

        CmsSitemapData result = null;
        CmsObject cms = getCmsObject();
        try {
            CmsResource sitemap = cms.readResource(sitemapUri);
            result = new CmsSitemapData(
                getDefaultTemplate(sitemapUri),
                getTemplates(),
                CmsXmlContentPropertyHelper.getPropertyInfo(cms, sitemap),
                getCachedRecentList(),
                getNoEditReason(cms, getRequest()),
                isDisplayToolbar(getRequest()),
                OpenCms.getResourceManager().getResourceType(CmsResourceTypeXmlContainerPage.getStaticTypeName()).getTypeId(),
                OpenCms.getSitemapManager().getParentSitemap(cms, sitemapUri),
                getRoot(sitemap),
                sitemap.getDateLastModified());
        } catch (Throwable e) {
            error(e);
        }
        return result;
    }

    /**
     * @see org.opencms.ade.sitemap.shared.rpc.I_CmsSitemapService#save(java.lang.String, List)
     */
    public void save(String sitemapUri, List<I_CmsSitemapChange> changes) throws CmsRpcException {

        CmsObject cms = getCmsObject();
        try {
            // TODO: what's about historical requests?
            CmsResource sitemap = cms.readResource(sitemapUri);
            CmsXmlSitemap xml = CmsXmlSitemapFactory.unmarshal(cms, sitemap);
            // apply changes
            xml.applyChanges(cms, changes);
            // write to VFS
            xml.getFile().setContents(xml.marshal());
            cms.writeFile(xml.getFile());
            // and unlock
            cms.unlockResource(sitemapUri);
        } catch (Throwable e) {
            error(e);
        }
    }

    /**
     * @see org.opencms.ade.sitemap.shared.rpc.I_CmsSitemapService#saveSync(java.lang.String, java.util.List)
     */
    public void saveSync(String sitemapUri, List<I_CmsSitemapChange> changes) throws CmsRpcException {

        save(sitemapUri, changes);
    }

    /**
     * Returns the cached recent list, creating it if it doesn't already exist.<p>
     * 
     * @return the cached recent list
     */
    @SuppressWarnings("unchecked")
    private List<CmsClientSitemapEntry> getCachedRecentList() {

        List<CmsClientSitemapEntry> cache = (List<CmsClientSitemapEntry>)getRequest().getSession().getAttribute(
            SESSION_ATTR_ADE_SITEMAP_RECENT_LIST_CACHE);
        if (cache == null) {
            cache = new ArrayList<CmsClientSitemapEntry>();
            getRequest().getSession().setAttribute(SESSION_ATTR_ADE_SITEMAP_RECENT_LIST_CACHE, cache);
        }
        return cache;

    }

    /**
     * Returns the sitemap children for the given path with all descendants up to the given level, ie. 
     * <dl><dt>levels=1</dt><dd>only children</dd><dt>levels=2</dt><dd>children and great children</dd></dl>
     * and so on.<p>
     * 
     * @param root the site relative root
     * @param levels the levels to recurse
     *  
     * @return the sitemap children
     * 
     * @throws CmsException if something goes wrong 
     */
    private List<CmsClientSitemapEntry> getChildren(String root, int levels) throws CmsException {

        CmsObject cms = getCmsObject();
        CmsSitemapEntry entry = OpenCms.getSitemapManager().getEntryForUri(cms, root);
        List<CmsClientSitemapEntry> children = new ArrayList<CmsClientSitemapEntry>();
        if (entry.getProperties().get(CmsSitemapManager.Property.sitemap.name()) != null) {
            return children;
        }
        for (CmsSitemapEntry subEntry : OpenCms.getSitemapManager().getSubEntries(cms, root)) {
            CmsClientSitemapEntry child = toClientEntry(subEntry);
            children.add(child);
            if (levels > 1) {
                child.setSubEntries(getChildren(child.getSitePath(), levels - 1));
            }
        }
        return children;
    }

    /**
     * Returns the default template for the given sitemap.<p>
     * 
     * @param sitemapUri the sitemap URI
     * 
     * @return the default template
     * 
     * @throws CmsRpcException if something goes wrong
     */
    private CmsSitemapTemplate getDefaultTemplate(String sitemapUri) throws CmsRpcException {

        CmsSitemapTemplate result = null;
        CmsObject cms = getCmsObject();
        try {
            result = getTemplateBean(cms, OpenCms.getSitemapManager().getDefaultTemplate(cms, sitemapUri, getRequest()));
        } catch (Throwable e) {
            error(e);
        }
        return result;
    }

    /**
     * Returns the reason why you are not allowed to edit the current resource.<p>
     * 
     * @param cms the current cms object
     * @param request the current request to get the default locale from 
     * 
     * @return an empty string if editable, the reason if not
     * 
     * @throws CmsException if something goes wrong
     */
    private String getNoEditReason(CmsObject cms, HttpServletRequest request) throws CmsException {

        CmsResourceUtil resUtil = new CmsResourceUtil(cms, getResource(cms, request));
        return resUtil.getNoEditReason(OpenCms.getWorkplaceManager().getWorkplaceLocale(cms));
    }

    /**
     * Returns the current resource, taken into account historical requests.<p>
     * 
     * @param cms the current cms object
     * @param request the current request to get the default locale from 
     * 
     * @return the current resource
     * 
     * @throws CmsException if something goes wrong
     */
    private CmsResource getResource(CmsObject cms, HttpServletRequest request) throws CmsException {

        CmsResource resource = (CmsResource)CmsHistoryResourceHandler.getHistoryResource(request);
        if (resource == null) {
            resource = cms.readResource(cms.getRequestContext().getUri());
        }
        return resource;
    }

    /**
     * Returns the root sitemap entry for the given sitemap.<p>
     * 
     * @param sitemap the sitemap resource
     *  
     * @return root sitemap entry
     * 
     * @throws Exception if something goes wrong 
     */
    private CmsClientSitemapEntry getRoot(CmsResource sitemap) throws Exception {

        CmsObject cms = getCmsObject();

        // TODO: what's about historical requests?
        CmsXmlSitemap xml = CmsXmlSitemapFactory.unmarshal(cms, sitemap);
        CmsClientSitemapEntry root = toClientEntry(xml.getSitemap(cms, cms.getRequestContext().getLocale()).getSiteEntries().get(
            0));
        root.setSubEntries(getChildren(root.getSitePath(), 2));
        return root;
    }

    /**
     * Returns a bean representing the given template resource.<p>
     * 
     * @param cms the cms context to use for VFS operations
     * @param resource the template resource
     * 
     * @return bean representing the given template resource
     * 
     * @throws CmsException if something goes wrong 
     */
    private CmsSitemapTemplate getTemplateBean(CmsObject cms, CmsResource resource) throws CmsException {

        CmsProperty titleProp = cms.readPropertyObject(resource, CmsPropertyDefinition.PROPERTY_TITLE, false);
        CmsProperty descProp = cms.readPropertyObject(resource, CmsPropertyDefinition.PROPERTY_DESCRIPTION, false);
        CmsProperty imageProp = cms.readPropertyObject(
            resource,
            CmsPropertyDefinition.PROPERTY_ADE_TEMPLATE_IMAGE,
            false);
        return new CmsSitemapTemplate(
            titleProp.getValue(),
            descProp.getValue(),
            cms.getSitePath(resource),
            imageProp.getValue());
    }

    /**
     * Checks if the toolbar should be displayed.<p>
     * 
     * @param request the current request to get the default locale from 
     * 
     * @return <code>true</code> if the toolbar should be displayed
     */
    private boolean isDisplayToolbar(HttpServletRequest request) {

        // display the toolbar by default
        boolean displayToolbar = true;
        if (CmsHistoryResourceHandler.isHistoryRequest(request)) {
            // we do not want to display the toolbar in case of an historical request
            displayToolbar = false;
        }
        return displayToolbar;
    }

    /**
     * Saves the given recent list to the session.<p>
     * 
     * @param recentList the recent list to save
     */
    private void setRecentList(List<CmsClientSitemapEntry> recentList) {

        getRequest().getSession().setAttribute(SESSION_ATTR_ADE_SITEMAP_RECENT_LIST_CACHE, recentList);
    }

    /**
     * Converts a site entry bean into a JSON object.<p>
     * 
     * @param entry the entry to convert
     * 
     * @return the JSON representation, can be <code>null</code> in case of not enough permissions
     * 
     * @throws CmsException should never happen 
     */
    private CmsClientSitemapEntry toClientEntry(CmsSitemapEntry entry) throws CmsException {

        CmsClientSitemapEntry clientEntry = new CmsClientSitemapEntry();
        clientEntry.setId(entry.getId());
        clientEntry.setName(entry.getName());
        clientEntry.setTitle(entry.getTitle());
        String vfsPath;
        try {
            vfsPath = getCmsObject().getSitePath(getCmsObject().readResource(entry.getResourceId()));
        } catch (CmsVfsResourceNotFoundException e) {
            vfsPath = e.getLocalizedMessage(getCmsObject().getRequestContext().getLocale());
        }
        clientEntry.setVfsPath(vfsPath);
        clientEntry.setProperties(new HashMap<String, String>(entry.getProperties()));
        clientEntry.setSitePath(entry.getSitePath(getCmsObject()));
        clientEntry.setPosition(entry.getPosition());
        return clientEntry;
    }
}
