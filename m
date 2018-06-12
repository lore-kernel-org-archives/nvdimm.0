Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail2-relais-roc.national.inria.fr
 (mail2-relais-roc.national.inria.fr [192.134.164.83])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B1466212909DE
 for <linux-nvdimm@lists.01.org>; Tue, 12 Jun 2018 08:10:19 -0700 (PDT)
Date: Tue, 12 Jun 2018 17:10:12 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH v5 2/4] resource: Use list_head to link sibling resource
Message-ID: <alpine.DEB.2.20.1806121708070.3334@hadrien>
MIME-Version: 1.0
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
Cc: brijesh.singh@amd.com, thomas.lendacky@amd.com, airlied@linux.ie, linux-pci@vger.kernel.org, richard.weiyang@gmail.com, keith.busch@intel.com, jcmvbkbc@gmail.com, baiyaowei@cmss.chinamobile.com, frowand.list@gmail.com, lorenzo.pieralisi@arm.com, sthemmin@microsoft.com, linux-nvdimm@lists.01.org, patrik.r.jakobsson@gmail.com, linux-input@vger.kernel.org, gustavo@padovan.org, dyoung@redhat.com, kbuild-all@01.org, devicetree@vger.kernel.org, haiyangz@microsoft.com, maarten.lankhorst@linux.intel.com, jglisse@redhat.com, seanpaul@chromium.org, bhelgaas@google.com, tglx@linutronix.de, yinghai@kernel.org, jonathan.derrick@intel.com, chris@zankel.net, monstr@monstr.eu, linux-parisc@vger.kernel.org, gregkh@linuxfoundation.org, dmitry.torokhov@gmail.com, kexec@lists.infradead.org, ebiederm@xmission.com, devel@linuxdriverproject.org, linuxppc-dev@lists.ozlabs.org, davem@davemloft.net
List-ID: <linux-nvdimm@lists.01.org>

This looks wrong.  After a list iterator, the index variable points to a
dummy structure.

julia

url:    https://github.com/0day-ci/linux/commits/Baoquan-He/resource-Use-list_head-to-link-sibling-resource/20180612-113600
:::::: branch date: 7 hours ago
:::::: commit date: 7 hours ago

>> kernel/resource.c:265:17-20: ERROR: invalid reference to the index variable of the iterator on line 253

# https://github.com/0day-ci/linux/commit/e906f15906750a86913ba2b1f08bad99129d3dfc
git remote add linux-review https://github.com/0day-ci/linux
git remote update linux-review
git checkout e906f15906750a86913ba2b1f08bad99129d3dfc
vim +265 kernel/resource.c

^1da177e4 Linus Torvalds 2005-04-16  247
5eeec0ec9 Yinghai Lu     2009-12-22  248  static void __release_child_resources(struct resource *r)
5eeec0ec9 Yinghai Lu     2009-12-22  249  {
e906f1590 Baoquan He     2018-06-12  250  	struct resource *tmp, *next;
5eeec0ec9 Yinghai Lu     2009-12-22  251  	resource_size_t size;
5eeec0ec9 Yinghai Lu     2009-12-22  252
e906f1590 Baoquan He     2018-06-12 @253  	list_for_each_entry_safe(tmp, next, &r->child, sibling) {
5eeec0ec9 Yinghai Lu     2009-12-22  254  		tmp->parent = NULL;
e906f1590 Baoquan He     2018-06-12  255  		INIT_LIST_HEAD(&tmp->sibling);
5eeec0ec9 Yinghai Lu     2009-12-22  256  		__release_child_resources(tmp);
5eeec0ec9 Yinghai Lu     2009-12-22  257
5eeec0ec9 Yinghai Lu     2009-12-22  258  		printk(KERN_DEBUG "release child resource %pR\n", tmp);
5eeec0ec9 Yinghai Lu     2009-12-22  259  		/* need to restore size, and keep flags */
5eeec0ec9 Yinghai Lu     2009-12-22  260  		size = resource_size(tmp);
5eeec0ec9 Yinghai Lu     2009-12-22  261  		tmp->start = 0;
5eeec0ec9 Yinghai Lu     2009-12-22  262  		tmp->end = size - 1;
5eeec0ec9 Yinghai Lu     2009-12-22  263  	}
e906f1590 Baoquan He     2018-06-12  264
e906f1590 Baoquan He     2018-06-12 @265  	INIT_LIST_HEAD(&tmp->child);
5eeec0ec9 Yinghai Lu     2009-12-22  266  }
5eeec0ec9 Yinghai Lu     2009-12-22  267

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
