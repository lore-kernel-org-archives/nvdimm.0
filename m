Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE2B73FD5
	for <nvdimm@lists.linux.dev>; Fri,  3 Sep 2021 12:52:46 +0000 (UTC)
Received: from fraeml715-chm.china.huawei.com (unknown [172.18.147.201])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4H1Hj63v8nz67Zpp;
	Fri,  3 Sep 2021 20:51:06 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml715-chm.china.huawei.com (10.206.15.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Fri, 3 Sep 2021 14:52:43 +0200
Received: from localhost (10.52.121.127) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2308.8; Fri, 3 Sep 2021
 13:52:42 +0100
Date: Fri, 3 Sep 2021 13:52:43 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, Ben Widawsky <ben.widawsky@intel.com>,
	"Vishal Verma" <vishal.l.verma@intel.com>, <alison.schofield@intel.com>,
	<nvdimm@lists.linux.dev>, <ira.weiny@intel.com>
Subject: Re: [PATCH v3 24/28] tools/testing/cxl: Introduce a mocked-up CXL
 port hierarchy
Message-ID: <20210903135243.000064ac@Huawei.com>
In-Reply-To: <162982125348.1124374.17808192318402734926.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <162982112370.1124374.2020303588105269226.stgit@dwillia2-desk3.amr.corp.intel.com>
	<162982125348.1124374.17808192318402734926.stgit@dwillia2-desk3.amr.corp.intel.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; i686-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.52.121.127]
X-ClientProxiedBy: lhreml703-chm.china.huawei.com (10.201.108.52) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected

On Tue, 24 Aug 2021 09:07:33 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> Create an environment for CXL plumbing unit tests. Especially when it
> comes to an algorithm for HDM Decoder (Host-managed Device Memory
> Decoder) programming, the availability of an in-kernel-tree emulation
> environment for CXL configuration complexity and corner cases speeds
> development and deters regressions.
> 
> The approach taken mirrors what was done for tools/testing/nvdimm/. I.e.
> an external module, cxl_test.ko built out of the tools/testing/cxl/
> directory, provides mock implementations of kernel APIs and kernel
> objects to simulate a real world device hierarchy.
> 
> One feedback for the tools/testing/nvdimm/ proposal was "why not do this
> in QEMU?". In fact, the CXL development community has developed a QEMU
> model for CXL [1]. However, there are a few blocking issues that keep
> QEMU from being a tight fit for topology + provisioning unit tests:
> 
> 1/ The QEMU community has yet to show interest in merging any of this
>    support that has had patches on the list since November 2020. So,
>    testing CXL to date involves building custom QEMU with out-of-tree
>    patches.

That's a separate discussion I've been meaning to kick off. I'd like
to get that moving because there are various things we can do there
which can't necessarily be done with this approach or at least are easier
done in QEMU. I'll raise it on the qemu list and drag a few people in
who might be able to help us get things moving + help find solutions to
the bits that we can't currently do.

> 
> 2/ CXL mechanisms like cross-host-bridge interleave do not have a clear
>    path to be emulated by QEMU without major infrastructure work. This
>    is easier to achieve with the alloc_mock_res() approach taken in this
>    patch to shortcut-define emulated system physical address ranges with
>    interleave behavior.
> 
> The QEMU enabling has been critical to get the driver off the ground,
> and may still move forward, but it does not address the ongoing needs of
> a regression testing environment and test driven development.

Different purposes, so I would see having both as beneficial
(in principle - I haven't played with this yet :)

> 
> This patch adds an ACPI CXL Platform definition with emulated CXL
> multi-ported host-bridges. A follow on patch adds emulated memory
> expander devices.
> 
> Acked-by: Ben Widawsky <ben.widawsky@intel.com>
> Reported-by: Vishal Verma <vishal.l.verma@intel.com>
> Link: https://lore.kernel.org/r/20210202005948.241655-1-ben.widawsky@intel.com [1]
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/cxl/acpi.c               |   52 ++--
>  drivers/cxl/cxl.h                |   13 +
>  tools/testing/cxl/Kbuild         |   36 +++
>  tools/testing/cxl/config_check.c |   13 +
>  tools/testing/cxl/mock_acpi.c    |  109 ++++++++
>  tools/testing/cxl/test/Kbuild    |    6 
>  tools/testing/cxl/test/cxl.c     |  516 ++++++++++++++++++++++++++++++++++++++
>  tools/testing/cxl/test/mock.c    |  171 +++++++++++++
>  tools/testing/cxl/test/mock.h    |   27 ++
>  9 files changed, 922 insertions(+), 21 deletions(-)
>  create mode 100644 tools/testing/cxl/Kbuild
>  create mode 100644 tools/testing/cxl/config_check.c
>  create mode 100644 tools/testing/cxl/mock_acpi.c
>  create mode 100644 tools/testing/cxl/test/Kbuild
>  create mode 100644 tools/testing/cxl/test/cxl.c
>  create mode 100644 tools/testing/cxl/test/mock.c
>  create mode 100644 tools/testing/cxl/test/mock.h
> 
> diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
> index 2d8f1ec1abff..3fcb704c647f 100644
> --- a/drivers/cxl/acpi.c
> +++ b/drivers/cxl/acpi.c
> @@ -182,15 +182,7 @@ static resource_size_t get_chbcr(struct acpi_cedt_chbs *chbs)
>  	return IS_ERR(chbs) ? CXL_RESOURCE_NONE : chbs->base;
>  }

> -static int match_add_root_ports(struct pci_dev *pdev, void *data)
> +__mock int match_add_root_ports(struct pci_dev *pdev, void *data)
>  {
>  	struct cxl_walk_context *ctx = data;
>  	struct pci_bus *root_bus = ctx->root;
> @@ -214,6 +206,8 @@ static int match_add_root_ports(struct pci_dev *pdev, void *data)
>  	port_num = FIELD_GET(PCI_EXP_LNKCAP_PN, lnkcap);
>  	rc = cxl_add_dport(port, &pdev->dev, port_num, CXL_RESOURCE_NONE);
>  	if (rc) {
> +		dev_err(dev, "failed to add dport: %s (%d)\n",
> +			dev_name(&pdev->dev), rc);

*grumble*  This extra debug is reasonable but not much to do with the
functionality of this patch.  So should have been separate to cut down on noise
here.


>  		ctx->error = rc;
>  		return rc;
>  	}
> @@ -239,15 +233,18 @@ static struct cxl_dport *find_dport_by_dev(struct cxl_port *port, struct device
>  	return NULL;
>  }
>  
> -static struct acpi_device *to_cxl_host_bridge(struct device *dev)
> +__mock struct acpi_device *to_cxl_host_bridge(struct device *host,
> +					      struct device *dev)
>  {
>  	struct acpi_device *adev = to_acpi_device(dev);
>  
>  	if (!acpi_pci_find_root(adev->handle))
>  		return NULL;
>  
> -	if (strcmp(acpi_device_hid(adev), "ACPI0016") == 0)
> +	if (strcmp(acpi_device_hid(adev), "ACPI0016") == 0) {
> +		dev_dbg(host, "found host bridge %s\n", dev_name(&adev->dev));
>  		return adev;
> +	}
>  	return NULL;
>  }
>  
> @@ -257,14 +254,14 @@ static struct acpi_device *to_cxl_host_bridge(struct device *dev)
>   */
>  static int add_host_bridge_uport(struct device *match, void *arg)
>  {
> -	struct acpi_device *bridge = to_cxl_host_bridge(match);
> +	struct cxl_port *port;
> +	struct cxl_dport *dport;
> +	struct cxl_decoder *cxld;
> +	struct cxl_walk_context ctx;
> +	struct acpi_pci_root *pci_root;
>  	struct cxl_port *root_port = arg;
>  	struct device *host = root_port->dev.parent;
> -	struct acpi_pci_root *pci_root;
> -	struct cxl_walk_context ctx;
> -	struct cxl_decoder *cxld;
> -	struct cxl_dport *dport;
> -	struct cxl_port *port;

Going from reverse xmas tree (almost) to xmas tree in a patch doing something else?
 
> +	struct acpi_device *bridge = to_cxl_host_bridge(host, match);
>  
>  	if (!bridge)
>  		return 0;
> @@ -319,7 +316,7 @@ static int add_host_bridge_dport(struct device *match, void *arg)
>  	struct acpi_cedt_chbs *chbs;
>  	struct cxl_port *root_port = arg;
>  	struct device *host = root_port->dev.parent;
> -	struct acpi_device *bridge = to_cxl_host_bridge(match);
> +	struct acpi_device *bridge = to_cxl_host_bridge(host, match);
>  
>  	if (!bridge)
>  		return 0;
> @@ -371,6 +368,17 @@ static int add_root_nvdimm_bridge(struct device *match, void *data)
>  	return 1;
>  }
>  
...


> diff --git a/tools/testing/cxl/mock_acpi.c b/tools/testing/cxl/mock_acpi.c
> new file mode 100644
> index 000000000000..4c8a493ace56
> --- /dev/null
> +++ b/tools/testing/cxl/mock_acpi.c
> @@ -0,0 +1,109 @@

> +static int match_add_root_port(struct pci_dev *pdev, void *data)

Hmm. Nice not to duplicate this code, but I guess a bit tricky to
work around.  Maybe a comment next to the 'main' version so we
remember to update this one as well if it is changed?

> +{
> +	struct cxl_walk_context *ctx = data;
> +	struct pci_bus *root_bus = ctx->root;
> +	struct cxl_port *port = ctx->port;
> +	int type = pci_pcie_type(pdev);
> +	struct device *dev = ctx->dev;
> +	u32 lnkcap, port_num;
> +	int rc;
> +
> +	if (pdev->bus != root_bus)
> +		return 0;
> +	if (!pci_is_pcie(pdev))
> +		return 0;
> +	if (type != PCI_EXP_TYPE_ROOT_PORT)
> +		return 0;
> +	if (pci_read_config_dword(pdev, pci_pcie_cap(pdev) + PCI_EXP_LNKCAP,
> +				  &lnkcap) != PCIBIOS_SUCCESSFUL)
> +		return 0;
> +
> +	/* TODO walk DVSEC to find component register base */
> +	port_num = FIELD_GET(PCI_EXP_LNKCAP_PN, lnkcap);
> +	rc = cxl_add_dport(port, &pdev->dev, port_num, CXL_RESOURCE_NONE);
> +	if (rc) {
> +		dev_err(dev, "failed to add dport: %s (%d)\n",
> +			dev_name(&pdev->dev), rc);
> +		ctx->error = rc;
> +		return rc;
> +	}
> +	ctx->count++;
> +
> +	dev_dbg(dev, "add dport%d: %s\n", port_num, dev_name(&pdev->dev));
> +
> +	return 0;
> +}
> +
> +static int mock_add_root_port(struct platform_device *pdev, void *data)
> +{
> +	struct cxl_walk_context *ctx = data;
> +	struct cxl_port *port = ctx->port;
> +	struct device *dev = ctx->dev;
> +	int rc;
> +
> +	rc = cxl_add_dport(port, &pdev->dev, pdev->id, CXL_RESOURCE_NONE);
> +	if (rc) {
> +		dev_err(dev, "failed to add dport: %s (%d)\n",
> +			dev_name(&pdev->dev), rc);
> +		ctx->error = rc;
> +		return rc;
> +	}
> +	ctx->count++;
> +
> +	dev_dbg(dev, "add dport%d: %s\n", pdev->id, dev_name(&pdev->dev));
> +
> +	return 0;
> +}
> +
> +int match_add_root_ports(struct pci_dev *dev, void *data)
> +{
> +	int index, rc;
> +	struct cxl_mock_ops *ops = get_cxl_mock_ops(&index);
> +	struct platform_device *pdev = (struct platform_device *) dev;
> +
> +	if (ops && ops->is_mock_port(pdev))
> +		rc = mock_add_root_port(pdev, data);
> +	else
> +		rc = match_add_root_port(dev, data);
> +
> +	put_cxl_mock_ops(index);
> +
> +	return rc;
> +}

...

> diff --git a/tools/testing/cxl/test/cxl.c b/tools/testing/cxl/test/cxl.c
> new file mode 100644
> index 000000000000..0710e0062e58
> --- /dev/null
> +++ b/tools/testing/cxl/test/cxl.c
> @@ -0,0 +1,516 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +// Copyright(c) 2021 Intel Corporation. All rights reserved.
> +
> +#include <linux/platform_device.h>
> +#include <linux/genalloc.h>
> +#include <linux/module.h>
> +#include <linux/mutex.h>
> +#include <linux/acpi.h>
> +#include <linux/pci.h>
> +#include <linux/mm.h>
> +#include "mock.h"
> +
> +#define NR_CXL_HOST_BRIDGES 4
> +#define NR_CXL_ROOT_PORTS 2
> +
> +static struct platform_device *cxl_acpi;
> +static struct platform_device *cxl_host_bridge[NR_CXL_HOST_BRIDGES];
> +static struct platform_device
> +	*cxl_root_port[NR_CXL_HOST_BRIDGES * NR_CXL_ROOT_PORTS];
> +
> +static struct acpi_device acpi0017_mock;
> +static struct acpi_device host_bridge[NR_CXL_HOST_BRIDGES] = {
> +	[0] = {
> +		.handle = &host_bridge[0],
> +	},
> +	[1] = {
> +		.handle = &host_bridge[1],
> +	},
> +	[2] = {
> +		.handle = &host_bridge[2],
> +	},
> +	[3] = {
> +		.handle = &host_bridge[3],
> +	},
> +};
> +
> +static bool is_mock_dev(struct device *dev)
> +{

You be paranoid and check acxl_acpi here but I guess
its always safe...

> +	if (dev == &cxl_acpi->dev)
> +		return true;
> +	return false;
> +}
> +

...

> +
> +struct cxl_mock_res {
> +	struct list_head list;
> +	struct range range;
> +};
> +
> +static LIST_HEAD(mock_res);
> +static DEFINE_MUTEX(mock_res_lock);
> +static struct gen_pool *cxl_mock_pool;
> +
> +static void free_mock_res(void)
Seems like a missmatch in naming.
free_mock_res() frees all resouces,
alloc_moc_res() allocates one.


> +{
> +	struct cxl_mock_res *res, *_res;
> +
> +	mutex_lock(&mock_res_lock);
> +	list_for_each_entry_safe(res, _res, &mock_res, list) {
> +		gen_pool_free(cxl_mock_pool, res->range.start,
> +			      range_len(&res->range));
> +		list_del(&res->list);
> +		kfree(res);
> +	}
> +	mutex_unlock(&mock_res_lock);
> +}
> +
> +static struct cxl_mock_res *alloc_mock_res(resource_size_t size)
> +{
> +	struct cxl_mock_res *res = kzalloc(sizeof(*res), GFP_KERNEL);
> +	struct genpool_data_align data = {
> +		.align = SZ_256M,
> +	};
> +	unsigned long phys;
> +
> +	INIT_LIST_HEAD(&res->list);
> +	phys = gen_pool_alloc_algo(cxl_mock_pool, size,
> +				   gen_pool_first_fit_align, &data);
> +	if (!phys)
> +		return NULL;
> +
> +	res->range = (struct range) {
> +		.start = phys,
> +		.end = phys + size - 1,
> +	};
> +	mutex_lock(&mock_res_lock);
> +	list_add(&res->list, &mock_res);
> +	mutex_unlock(&mock_res_lock);
> +
> +	return res;
> +}
> +
> +static int populate_cedt(void)
> +{
> +	struct acpi_cedt_cfmws *cfmws[4] = {
> +		[0] = &mock_cedt.cfmws0.cfmws,
> +		[1] = &mock_cedt.cfmws1.cfmws,
> +		[2] = &mock_cedt.cfmws2.cfmws,
> +		[3] = &mock_cedt.cfmws3.cfmws,
> +	};
> +	struct cxl_mock_res *res;
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(mock_cedt.chbs); i++) {
> +		struct acpi_cedt_chbs *chbs = &mock_cedt.chbs[i];
> +		resource_size_t size;
> +
> +		if (chbs->cxl_version == ACPI_CEDT_CHBS_VERSION_CXL20)
> +			size = ACPI_CEDT_CHBS_LENGTH_CXL20;
> +		else
> +			size = ACPI_CEDT_CHBS_LENGTH_CXL11;
> +
> +		res = alloc_mock_res(size);
> +		if (!res)
> +			return -ENOMEM;
> +		chbs->base = res->range.start;
> +		chbs->length = size;
> +	}
> +
> +	for (i = 0; i < ARRAY_SIZE(cfmws); i++) {
> +		struct acpi_cedt_cfmws *window = cfmws[i];
> +		int ways = 1 << window->interleave_ways;
> +
> +		res = alloc_mock_res(SZ_256M * ways);

why that size?  Should take window_size into account I think..

> +		if (!res)
> +			return -ENOMEM;
> +		window->base_hpa = res->range.start;
> +		window->window_size = range_len(&res->range);
> +	}
> +
> +	return 0;
> +}
> +


...

> +
> +static struct cxl_mock_ops cxl_mock_ops = {
> +	.is_mock_adev = is_mock_adev,
> +	.is_mock_bridge = is_mock_bridge,
> +	.is_mock_bus = is_mock_bus,
> +	.is_mock_port = is_mock_port,
> +	.is_mock_dev = is_mock_dev,
> +	.mock_port = mock_cxl_root_port,
> +	.acpi_get_table = mock_acpi_get_table,
> +	.acpi_put_table = mock_acpi_put_table,
> +	.acpi_evaluate_integer = mock_acpi_evaluate_integer,
> +	.acpi_pci_find_root = mock_acpi_pci_find_root,
> +	.list = LIST_HEAD_INIT(cxl_mock_ops.list),
> +};

...

> +#ifndef SZ_64G
> +#define SZ_64G (SZ_32G * 2)
> +#endif
> +
> +#ifndef SZ_512G
> +#define SZ_512G (SZ_64G * 8)
> +#endif

Why not add to sizes.h?

> +
> +static __init int cxl_test_init(void)
> +{
> +	int rc, i;
> +
> +	register_cxl_mock_ops(&cxl_mock_ops);
> +
> +	cxl_mock_pool = gen_pool_create(ilog2(SZ_2M), NUMA_NO_NODE);
> +	if (!cxl_mock_pool) {
> +		rc = -ENOMEM;
> +		goto err_gen_pool_create;
> +	}
> +
> +	rc = gen_pool_add(cxl_mock_pool, SZ_512G, SZ_64G, NUMA_NO_NODE);
> +	if (rc)
> +		goto err_gen_pool_add;
> +
> +	rc = populate_cedt();
> +	if (rc)
> +		goto err_populate;
> +
> +	for (i = 0; i < ARRAY_SIZE(cxl_host_bridge); i++) {
> +		struct acpi_device *adev = &host_bridge[i];
> +		struct platform_device *pdev;
> +
> +		pdev = platform_device_alloc("cxl_host_bridge", i);
> +		if (!pdev)
> +			goto err_bridge;
> +
> +		mock_companion(adev, &pdev->dev);
> +		rc = platform_device_add(pdev);
> +		if (rc) {
> +			platform_device_put(pdev);
> +			goto err_bridge;
> +		}
> +		cxl_host_bridge[i] = pdev;
> +	}
> +
> +	for (i = 0; i < ARRAY_SIZE(cxl_root_port); i++) {
> +		struct platform_device *bridge =
> +			cxl_host_bridge[i / NR_CXL_ROOT_PORTS];
> +		struct platform_device *pdev;
> +
> +		pdev = platform_device_alloc("cxl_root_port", i);
> +		if (!pdev)
> +			goto err_port;
> +		pdev->dev.parent = &bridge->dev;
> +
> +		rc = platform_device_add(pdev);
> +		if (rc) {
> +			platform_device_put(pdev);
> +			goto err_port;
> +		}
> +		cxl_root_port[i] = pdev;
> +	}
> +
> +	cxl_acpi = platform_device_alloc("cxl_acpi", 0);
> +	if (!cxl_acpi)
> +		goto err_port;
> +
> +	mock_companion(&acpi0017_mock, &cxl_acpi->dev);
> +	acpi0017_mock.dev.bus = &platform_bus_type;
> +
> +	rc = platform_device_add(cxl_acpi);
> +	if (rc)
> +		goto err_add;
> +
> +	return 0;
> +
> +err_add:
> +	platform_device_put(cxl_acpi);
> +err_port:
> +	for (i = ARRAY_SIZE(cxl_root_port) - 1; i >= 0; i--) {
> +		platform_device_del(cxl_root_port[i]);
> +		platform_device_put(cxl_root_port[i]);
> +	}
> +err_bridge:
> +	for (i = ARRAY_SIZE(cxl_host_bridge) - 1; i >= 0; i--) {
> +		platform_device_del(cxl_host_bridge[i]);
> +		platform_device_put(cxl_host_bridge[i]);
> +	}
> +err_populate:
> +	free_mock_res();

Might be worth a function wrapping this that makes it clear this
is unwinding what happened in populate_cedt()

> +err_gen_pool_add:
> +	gen_pool_destroy(cxl_mock_pool);
> +err_gen_pool_create:
> +	unregister_cxl_mock_ops(&cxl_mock_ops);
> +	return rc;
> +}
> +
> +static __exit void cxl_test_exit(void)
> +{
> +	int i;
> +
> +	platform_device_del(cxl_acpi);
> +	platform_device_put(cxl_acpi);

Given the evil warning comments about platform_device_del() in platform.c
about it only being appropriate to call it in error cases...

Perhaps it's better to call platform_device_unregister() even if
that looks locally less obvious?  Or maybe we should suggest
the warning comments are more refined in what usage to rule out!

> +	for (i = ARRAY_SIZE(cxl_root_port) - 1; i >= 0; i--) {
> +		platform_device_del(cxl_root_port[i]);
> +		platform_device_put(cxl_root_port[i]);
> +	}
> +	for (i = ARRAY_SIZE(cxl_host_bridge) - 1; i >= 0; i--) {
> +		platform_device_del(cxl_host_bridge[i]);
> +		platform_device_put(cxl_host_bridge[i]);
> +	}
> +	free_mock_res();
> +	gen_pool_destroy(cxl_mock_pool);
> +	unregister_cxl_mock_ops(&cxl_mock_ops);
> +}
> +
> +module_init(cxl_test_init);
> +module_exit(cxl_test_exit);
> +MODULE_LICENSE("GPL v2");

...

Thanks,

Jonathan


