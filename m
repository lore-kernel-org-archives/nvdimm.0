Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 73A22211D07A1
 for <linux-nvdimm@lists.01.org>; Mon, 11 Jun 2018 21:50:20 -0700 (PDT)
Date: Tue, 12 Jun 2018 12:49:55 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH v5 2/4] resource: Use list_head to link sibling resource
Message-ID: <201806121251.hDRqpKgN%fengguang.wu@intel.com>
References: <20180612032831.29747-3-bhe@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20180612032831.29747-3-bhe@redhat.com>
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
Cc: nicolas.pitre@linaro.org, brijesh.singh@amd.com, thomas.lendacky@amd.com, airlied@linux.ie, linux-pci@vger.kernel.org, richard.weiyang@gmail.com, keith.busch@intel.com, jcmvbkbc@gmail.com, baiyaowei@cmss.chinamobile.com, frowand.list@gmail.com, tglx@linutronix.de, lorenzo.pieralisi@arm.com, sthemmin@microsoft.com, linux-nvdimm@lists.01.org, patrik.r.jakobsson@gmail.com, linux-input@vger.kernel.org, gustavo@padovan.org, bp@suse.de, dyoung@redhat.com, ebiederm@xmission.com, devicetree@vger.kernel.org, haiyangz@microsoft.com, maarten.lankhorst@linux.intel.com, josh@joshtriplett.org, jglisse@redhat.com, robh+dt@kernel.org, seanpaul@chromium.org, bhelgaas@google.com, yinghai@kernel.org, jonathan.derrick@intel.com, chris@zankel.net, monstr@monstr.eu, linux-parisc@vger.kernel.org, gregkh@linuxfoundation.org, dmitry.torokhov@gmail.com, kexec@lists.infradead.org, linux-kernel@vger.kernel.org, kbuild-all@01.org, devel@linuxdriverproject.org, akpm@linux-foundation.org, fengguang.wu@intel.com, linuxppc-dev@lists.ozlabs.org, davem@davemloft.net
List-ID: <linux-nvdimm@lists.01.org>

Hi Baoquan,

I love your patch! Perhaps something to improve:

[auto build test WARNING on linus/master]
[also build test WARNING on v4.17 next-20180608]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Baoquan-He/resource-Use-list_head-to-link-sibling-resource/20180612-113600
config: x86_64-randconfig-x011-201823 (attached as .config)
compiler: gcc-7 (Debian 7.3.0-16) 7.3.0
reproduce:
        # save the attached .config to linux build tree
        make ARCH=x86_64 

All warnings (new ones prefixed by >>):

   kernel/resource.c: In function 'reparent_resources':
   kernel/resource.c:1005:26: error: passing argument 2 of 'list_add' from incompatible pointer type [-Werror=incompatible-pointer-types]
     list_add(&res->sibling, &p->sibling.prev);
                             ^
   In file included from include/linux/ioport.h:15:0,
                    from kernel/resource.c:14:
   include/linux/list.h:77:20: note: expected 'struct list_head *' but argument is of type 'struct list_head **'
    static inline void list_add(struct list_head *new, struct list_head *head)
                       ^~~~~~~~
   In file included from include/linux/list.h:9:0,
                    from include/linux/ioport.h:15,
                    from kernel/resource.c:14:
   kernel/resource.c:1013:26: error: 'new' undeclared (first use in this function); did you mean 'net'?
     list_for_each_entry(p, &new->child, sibling) {
                             ^
   include/linux/kernel.h:963:26: note: in definition of macro 'container_of'
     void *__mptr = (void *)(ptr);     \
                             ^~~
   include/linux/list.h:377:2: note: in expansion of macro 'list_entry'
     list_entry((ptr)->next, type, member)
     ^~~~~~~~~~
   include/linux/list.h:464:13: note: in expansion of macro 'list_first_entry'
     for (pos = list_first_entry(head, typeof(*pos), member); \
                ^~~~~~~~~~~~~~~~
>> kernel/resource.c:1013:2: note: in expansion of macro 'list_for_each_entry'
     list_for_each_entry(p, &new->child, sibling) {
     ^~~~~~~~~~~~~~~~~~~
   kernel/resource.c:1013:26: note: each undeclared identifier is reported only once for each function it appears in
     list_for_each_entry(p, &new->child, sibling) {
                             ^
   include/linux/kernel.h:963:26: note: in definition of macro 'container_of'
     void *__mptr = (void *)(ptr);     \
                             ^~~
   include/linux/list.h:377:2: note: in expansion of macro 'list_entry'
     list_entry((ptr)->next, type, member)
     ^~~~~~~~~~
   include/linux/list.h:464:13: note: in expansion of macro 'list_first_entry'
     for (pos = list_first_entry(head, typeof(*pos), member); \
                ^~~~~~~~~~~~~~~~
>> kernel/resource.c:1013:2: note: in expansion of macro 'list_for_each_entry'
     list_for_each_entry(p, &new->child, sibling) {
     ^~~~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors

vim +/list_for_each_entry +1013 kernel/resource.c

   983	
   984	/*
   985	 * Reparent resource children of pr that conflict with res
   986	 * under res, and make res replace those children.
   987	 */
   988	int reparent_resources(struct resource *parent, struct resource *res)
   989	{
   990		struct resource *p, *first = NULL;
   991	
   992		list_for_each_entry(p, &parent->child, sibling) {
   993			if (p->end < res->start)
   994				continue;
   995			if (res->end < p->start)
   996				break;
   997			if (p->start < res->start || p->end > res->end)
   998				return -1;	/* not completely contained */
   999			if (first == NULL)
  1000				first = p;
  1001		}
  1002		if (first == NULL)
  1003			return -1;	/* didn't find any conflicting entries? */
  1004		res->parent = parent;
  1005		list_add(&res->sibling, &p->sibling.prev);
  1006		INIT_LIST_HEAD(&res->child);
  1007	
  1008		/*
  1009		 * From first to p's previous sibling, they all fall into
  1010		 * res's region, change them as res's children.
  1011		 */
  1012		list_cut_position(&res->child, first->sibling.prev, res->sibling.prev);
> 1013		list_for_each_entry(p, &new->child, sibling) {
  1014	                p->parent = new;
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
