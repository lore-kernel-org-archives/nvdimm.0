Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 96CA7203BBB80
 for <linux-nvdimm@lists.01.org>; Sun,  3 Feb 2019 06:32:28 -0800 (PST)
Date: Sun, 3 Feb 2019 22:31:47 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH] libnvdimm/dimm: Add a no-BLK quirk based on NVDIMM family
Message-ID: <201902032230.og6GVIra%fengguang.wu@intel.com>
References: <154915640488.3541628.4947340559510114602.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
In-Reply-To: <154915640488.3541628.4947340559510114602.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Disposition: inline
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, kbuild-all@01.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Hi Dan,

I love your patch! Yet something to improve:

[auto build test ERROR on linux-nvdimm/libnvdimm-for-next]
[also build test ERROR on v5.0-rc4 next-20190201]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Dan-Williams/libnvdimm-dimm-Add-a-no-BLK-quirk-based-on-NVDIMM-family/20190203-213444
base:   https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git libnvdimm-for-next
config: x86_64-randconfig-x018-201905 (attached as .config)
compiler: gcc-8 (Debian 8.2.0-14) 8.2.0
reproduce:
        # save the attached .config to linux build tree
        make ARCH=x86_64 

All errors (new ones prefixed by >>):

   drivers/acpi//nfit/core.c: In function 'acpi_nfit_register_dimms':
>> drivers/acpi//nfit/core.c:2003:27: error: 'NVDIMM_FAMILY_HYPERV' undeclared (first use in this function); did you mean 'NVDIMM_FAMILY_HPE2'?
      if (nfit_mem->family == NVDIMM_FAMILY_HYPERV)
                              ^~~~~~~~~~~~~~~~~~~~
                              NVDIMM_FAMILY_HPE2
   drivers/acpi//nfit/core.c:2003:27: note: each undeclared identifier is reported only once for each function it appears in

vim +2003 drivers/acpi//nfit/core.c

  1944	
  1945	static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
  1946	{
  1947		struct nfit_mem *nfit_mem;
  1948		int dimm_count = 0, rc;
  1949		struct nvdimm *nvdimm;
  1950	
  1951		list_for_each_entry(nfit_mem, &acpi_desc->dimms, list) {
  1952			struct acpi_nfit_flush_address *flush;
  1953			unsigned long flags = 0, cmd_mask;
  1954			struct nfit_memdev *nfit_memdev;
  1955			u32 device_handle;
  1956			u16 mem_flags;
  1957	
  1958			device_handle = __to_nfit_memdev(nfit_mem)->device_handle;
  1959			nvdimm = acpi_nfit_dimm_by_handle(acpi_desc, device_handle);
  1960			if (nvdimm) {
  1961				dimm_count++;
  1962				continue;
  1963			}
  1964	
  1965			if (nfit_mem->bdw && nfit_mem->memdev_pmem)
  1966				set_bit(NDD_ALIASING, &flags);
  1967	
  1968			/* collate flags across all memdevs for this dimm */
  1969			list_for_each_entry(nfit_memdev, &acpi_desc->memdevs, list) {
  1970				struct acpi_nfit_memory_map *dimm_memdev;
  1971	
  1972				dimm_memdev = __to_nfit_memdev(nfit_mem);
  1973				if (dimm_memdev->device_handle
  1974						!= nfit_memdev->memdev->device_handle)
  1975					continue;
  1976				dimm_memdev->flags |= nfit_memdev->memdev->flags;
  1977			}
  1978	
  1979			mem_flags = __to_nfit_memdev(nfit_mem)->flags;
  1980			if (mem_flags & ACPI_NFIT_MEM_NOT_ARMED)
  1981				set_bit(NDD_UNARMED, &flags);
  1982	
  1983			rc = acpi_nfit_add_dimm(acpi_desc, nfit_mem, device_handle);
  1984			if (rc)
  1985				continue;
  1986	
  1987			/*
  1988			 * TODO: provide translation for non-NVDIMM_FAMILY_INTEL
  1989			 * devices (i.e. from nd_cmd to acpi_dsm) to standardize the
  1990			 * userspace interface.
  1991			 */
  1992			cmd_mask = 1UL << ND_CMD_CALL;
  1993			if (nfit_mem->family == NVDIMM_FAMILY_INTEL) {
  1994				/*
  1995				 * These commands have a 1:1 correspondence
  1996				 * between DSM payload and libnvdimm ioctl
  1997				 * payload format.
  1998				 */
  1999				cmd_mask |= nfit_mem->dsm_mask & NVDIMM_STANDARD_CMDMASK;
  2000			}
  2001	
  2002			/* Quirk to ignore LOCAL for labels on HYPERV DIMMs */
> 2003			if (nfit_mem->family == NVDIMM_FAMILY_HYPERV)
  2004				set_bit(NDD_NOBLK, &flags);
  2005	
  2006			if (test_bit(NFIT_MEM_LSR, &nfit_mem->flags)) {
  2007				set_bit(ND_CMD_GET_CONFIG_SIZE, &cmd_mask);
  2008				set_bit(ND_CMD_GET_CONFIG_DATA, &cmd_mask);
  2009			}
  2010			if (test_bit(NFIT_MEM_LSW, &nfit_mem->flags))
  2011				set_bit(ND_CMD_SET_CONFIG_DATA, &cmd_mask);
  2012	
  2013			flush = nfit_mem->nfit_flush ? nfit_mem->nfit_flush->flush
  2014				: NULL;
  2015			nvdimm = __nvdimm_create(acpi_desc->nvdimm_bus, nfit_mem,
  2016					acpi_nfit_dimm_attribute_groups,
  2017					flags, cmd_mask, flush ? flush->hint_count : 0,
  2018					nfit_mem->flush_wpq, &nfit_mem->id[0],
  2019					acpi_nfit_get_security_ops(nfit_mem->family));
  2020			if (!nvdimm)
  2021				return -ENOMEM;
  2022	
  2023			nfit_mem->nvdimm = nvdimm;
  2024			dimm_count++;
  2025	
  2026			if ((mem_flags & ACPI_NFIT_MEM_FAILED_MASK) == 0)
  2027				continue;
  2028	
  2029			dev_info(acpi_desc->dev, "%s flags:%s%s%s%s%s\n",
  2030					nvdimm_name(nvdimm),
  2031			  mem_flags & ACPI_NFIT_MEM_SAVE_FAILED ? " save_fail" : "",
  2032			  mem_flags & ACPI_NFIT_MEM_RESTORE_FAILED ? " restore_fail":"",
  2033			  mem_flags & ACPI_NFIT_MEM_FLUSH_FAILED ? " flush_fail" : "",
  2034			  mem_flags & ACPI_NFIT_MEM_NOT_ARMED ? " not_armed" : "",
  2035			  mem_flags & ACPI_NFIT_MEM_MAP_FAILED ? " map_fail" : "");
  2036	
  2037		}
  2038	
  2039		rc = nvdimm_bus_check_dimm_count(acpi_desc->nvdimm_bus, dimm_count);
  2040		if (rc)
  2041			return rc;
  2042	
  2043		/*
  2044		 * Now that dimms are successfully registered, and async registration
  2045		 * is flushed, attempt to enable event notification.
  2046		 */
  2047		list_for_each_entry(nfit_mem, &acpi_desc->dimms, list) {
  2048			struct kernfs_node *nfit_kernfs;
  2049	
  2050			nvdimm = nfit_mem->nvdimm;
  2051			if (!nvdimm)
  2052				continue;
  2053	
  2054			rc = nvdimm_security_setup_events(nvdimm);
  2055			if (rc < 0)
  2056				dev_warn(acpi_desc->dev,
  2057					"security event setup failed: %d\n", rc);
  2058	
  2059			nfit_kernfs = sysfs_get_dirent(nvdimm_kobj(nvdimm)->sd, "nfit");
  2060			if (nfit_kernfs)
  2061				nfit_mem->flags_attr = sysfs_get_dirent(nfit_kernfs,
  2062						"flags");
  2063			sysfs_put(nfit_kernfs);
  2064			if (!nfit_mem->flags_attr)
  2065				dev_warn(acpi_desc->dev, "%s: notifications disabled\n",
  2066						nvdimm_name(nvdimm));
  2067		}
  2068	
  2069		return devm_add_action_or_reset(acpi_desc->dev, shutdown_dimm_notify,
  2070				acpi_desc);
  2071	}
  2072	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
