Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-it0-x22b.google.com (mail-it0-x22b.google.com
 [IPv6:2607:f8b0:4001:c0b::22b])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C01441A1E28
 for <linux-nvdimm@lists.01.org>; Fri, 21 Oct 2016 19:42:36 -0700 (PDT)
Received: by mail-it0-x22b.google.com with SMTP id m138so25733804itm.0
 for <linux-nvdimm@lists.01.org>; Fri, 21 Oct 2016 19:42:36 -0700 (PDT)
MIME-Version: 1.0
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 21 Oct 2016 19:42:34 -0700
Message-ID: <CAPcyv4i7bjc420_M1iq02pTtGQJJmUEQYwAHQWOxdXTMANOgww@mail.gmail.com>
Subject: ndctl: release v55
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
To: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

This release incorporates the capabilities of the 4.9 kernel. Major
highlights include support for retrieving the health status of HPE
NVDIMMs, and new label manipulation / validation commands.

Commands:
    list: add HPE NVDIMM health reporting
    init-labels: initialize a namespace-label index-block
    check-labels: validate a namespace-label index-block
    create-namespace: fix crash when target region disabled
    bash-completion: add {en,dis}able-dimm and {check,init}-labels support

Tests:
    dsm-fail: check that namespaces stay disabled when label DSMs fail
    multi-pmem: validate pmem-region sub-division support
    libndctl: add btt-size check
    libndctl: test health event notification support
    device-dax: validate "invalidate on shutdown" behavior of dax devices
    device-dax: validate direct-i/o to device-dax mappings
    device-dax: check kernel fix for file offset to phys offset translation
    device-dax: check kernel fix for crash when reading /proc/<pid>/smaps
    clear: check kernel fix for making cleared badblocks stay cleared

Apis:
    daxctl_region_get_available_size: new, in support of dax sub-division
    daxctl_region_get_devname: new, in support of dax sub-division
    daxctl_region_get_dev_seed: new, in support of dax sub-division
    ndctl_dimm_get_health_eventfd: new, fires upon firmware health
event notification
    ndctl_cmd_cfg_read_get_size: new, simplifies label manipulation routines
    ndctl_dimm_get_available_labels: fix error return value to be ULONG_MAX
    ndctl_region_get_available_size: fix error return value to be ULLONG_MAX
    ndctl_dimm_cmd_new_cfg_{read,write}: fix to not overflow label area size

https://github.com/pmem/ndctl/releases/tag/v55
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
