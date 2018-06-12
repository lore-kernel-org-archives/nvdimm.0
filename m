Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 462D8210C66AF
 for <linux-nvdimm@lists.01.org>; Mon, 11 Jun 2018 20:56:09 -0700 (PDT)
Date: Tue, 12 Jun 2018 11:55:46 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH v5 1/4] resource: Move reparent_resources() to
 kernel/resource.c and make it public
Message-ID: <201806121130.gf9upRAU%fengguang.wu@intel.com>
References: <20180612032831.29747-2-bhe@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20180612032831.29747-2-bhe@redhat.com>
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
To: Baoquan He <bhe@redhat.com>
Cc: nicolas.pitre@linaro.org, brijesh.singh@amd.com, devicetree@vger.kernel.org, airlied@linux.ie, linux-pci@vger.kernel.org, richard.weiyang@gmail.com, keith.busch@intel.com, jcmvbkbc@gmail.com, Paul Mackerras <paulus@samba.org>, baiyaowei@cmss.chinamobile.com, kys@microsoft.com, frowand.list@gmail.com, lorenzo.pieralisi@arm.com, sthemmin@microsoft.com, linux-nvdimm@lists.01.org, Michael Ellerman <mpe@ellerman.id.au>, patrik.r.jakobsson@gmail.com, linux-input@vger.kernel.org, gustavo@padovan.org, bp@suse.de, dyoung@redhat.com, ebiederm@xmission.com, thomas.lendacky@amd.com, haiyangz@microsoft.com, maarten.lankhorst@linux.intel.com, josh@joshtriplett.org, jglisse@redhat.com, robh+dt@kernel.org, seanpaul@chromium.org, bhelgaas@google.com, tglx@linutronix.de, yinghai@kernel.org, jonathan.derrick@intel.com, chris@zankel.net, monstr@monstr.eu, linux-parisc@vger.kernel.org, gregkh@linuxfoundation.org, dmitry.torokhov@gmail.com, kexec@lists.infradead.org, linux-kernel@vger.kernel.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>, kbuild-all@01.org, devel@linuxdriverproject.org, akpm@linux-foundation.org, fengguang.wu@intel.com, linuxppc-dev@lists.ozlabs.org, davem@davemloft.net
List-ID: <linux-nvdimm@lists.01.org>

Hi Baoquan,

I love your patch! Yet something to improve:

[auto build test ERROR on linus/master]
[also build test ERROR on v4.17 next-20180608]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Baoquan-He/resource-Use-list_head-to-link-sibling-resource/20180612-113600
config: i386-tinyconfig (attached as .config)
compiler: gcc-7 (Debian 7.3.0-16) 7.3.0
reproduce:
        # save the attached .config to linux build tree
        make ARCH=i386 

Note: the linux-review/Baoquan-He/resource-Use-list_head-to-link-sibling-resource/20180612-113600 HEAD 5545e79eef6387857faf41cdffa7be6b1f5d4efe builds fine.
      It only hurts bisectibility.

All errors (new ones prefixed by >>):

>> kernel/resource.c:990:12: error: static declaration of 'reparent_resources' follows non-static declaration
    static int reparent_resources(struct resource *parent,
               ^~~~~~~~~~~~~~~~~~
   In file included from kernel/resource.c:14:0:
   include/linux/ioport.h:195:5: note: previous declaration of 'reparent_resources' was here
    int reparent_resources(struct resource *parent, struct resource *res);
        ^~~~~~~~~~~~~~~~~~
   kernel/resource.c:990:12: warning: 'reparent_resources' defined but not used [-Wunused-function]
    static int reparent_resources(struct resource *parent,
               ^~~~~~~~~~~~~~~~~~

vim +/reparent_resources +990 kernel/resource.c

   985	
   986	/*
   987	 * Reparent resource children of pr that conflict with res
   988	 * under res, and make res replace those children.
   989	 */
 > 990	static int reparent_resources(struct resource *parent,
   991					     struct resource *res)
   992	{
   993		struct resource *p, **pp;
   994		struct resource **firstpp = NULL;
   995	
   996		for (pp = &parent->child; (p = *pp) != NULL; pp = &p->sibling) {
   997			if (p->end < res->start)
   998				continue;
   999			if (res->end < p->start)
  1000				break;
  1001			if (p->start < res->start || p->end > res->end)
  1002				return -1;	/* not completely contained */
  1003			if (firstpp == NULL)
  1004				firstpp = pp;
  1005		}
  1006		if (firstpp == NULL)
  1007			return -1;	/* didn't find any conflicting entries? */
  1008		res->parent = parent;
  1009		res->child = *firstpp;
  1010		res->sibling = *pp;
  1011		*firstpp = res;
  1012		*pp = NULL;
  1013		for (p = res->child; p != NULL; p = p->sibling) {
  1014			p->parent = res;
  1015			pr_debug("PCI: Reparented %s %pR under %s\n",
  1016				 p->name, p, res->name);
  1017		}
  1018		return 0;
  1019	}
  1020	EXPORT_SYMBOL(reparent_resources);
  1021	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
