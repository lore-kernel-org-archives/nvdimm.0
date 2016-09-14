Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8ABC51A1E5B
 for <linux-nvdimm@lists.01.org>; Tue, 13 Sep 2016 20:42:11 -0700 (PDT)
Date: Wed, 14 Sep 2016 11:41:53 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 2/2] tools/testing/nvdimm: test get_config_size DSM
 failures
Message-ID: <201609141142.bs4dcrJ1%fengguang.wu@intel.com>
MIME-Version: 1.0
In-Reply-To: <147381653820.13555.4462846098098492278.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-acpi@vger.kernel.org, kbuild-all@01.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Hi Dan,

[auto build test WARNING on next-20160913]
[cannot apply to pm/linux-next linus/master linux/master v4.8-rc6 v4.8-rc5 v4.8-rc4 v4.8-rc6]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
[Suggest to use git(>=2.9.0) format-patch --base=<commit> (or --base=auto for convenience) to record what (public, well-known) commit your patch series was built on]
[Check https://git-scm.com/docs/git-format-patch for more information]

url:    https://github.com/0day-ci/linux/commits/Dan-Williams/nfit-fail-DSMs-that-return-non-zero-status-by-default/20160914-093545
config: x86_64-rhel (attached as .config)
compiler: gcc-6 (Debian 6.1.1-9) 6.1.1 20160705
reproduce:
        # save the attached .config to linux build tree
        make ARCH=x86_64 

All warnings (new ones prefixed by >>):

   tools/testing/nvdimm//test/nfit.c: In function 'handle_show':
>> tools/testing/nvdimm//test/nfit.c:609:26: warning: format '%lx' expects argument of type 'long unsigned int', but argument 3 has type 'u32 {aka unsigned int}' [-Wformat=]
     return sprintf(buf, "%#lx", handle[dimm]);
                             ^

vim +609 tools/testing/nvdimm//test/nfit.c

   593	
   594		if (sscanf(dev_name(dev), "test_dimm%d", &dimm) != 1
   595				|| dimm >= NUM_DCR || dimm < 0)
   596			return -ENXIO;
   597		return dimm;
   598	}
   599	
   600	
   601	static ssize_t handle_show(struct device *dev, struct device_attribute *attr,
   602			char *buf)
   603	{
   604		int dimm = dimm_name_to_id(dev);
   605	
   606		if (dimm < 0)
   607			return dimm;
   608	
 > 609		return sprintf(buf, "%#lx", handle[dimm]);
   610	}
   611	DEVICE_ATTR_RO(handle);
   612	
   613	static ssize_t fail_cmd_show(struct device *dev, struct device_attribute *attr,
   614			char *buf)
   615	{
   616		int dimm = dimm_name_to_id(dev);
   617	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
