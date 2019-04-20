From: Sasha Levin <sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] libnvdimm/namespace: Fix label tracking error
Date: Sat, 20 Apr 2019 01:19:13 +0000
Message-ID: <20190420011914.C966D20854@mail.kernel.org>
References: <155572004134.2603218.13620079500159805086.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <155572004134.2603218.13620079500159805086.stgit-p8uTFz9XbKj2zm6wflaqv1nYeNYlB/vhral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Sasha Levin <sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

Hi,

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag,
fixing commit: bf9bccc14c05 libnvdimm: pmem label sets and namespace instantiation..

The bot has tested the following trees: v5.0.8, v4.19.35, v4.14.112, v4.9.169, v4.4.178, 

v5.0.8: Build OK!
v4.19.35: Build OK!
v4.14.112: Failed to apply! Possible dependencies:
    426824d63b77 ("libnvdimm: remove redundant __func__ in dev_dbg")

v4.9.169: Failed to apply! Possible dependencies:
    006358b35c73 ("libnvdimm: add support for clear poison list and badblocks for device dax")
    355d838878e1 ("libnvdimm, label: add v1.2 label checksum support")
    426824d63b77 ("libnvdimm: remove redundant __func__ in dev_dbg")
    53b85a449b15 ("libnvdimm: passthru functions clear to send")
    564e871aa66f ("libnvdimm, label: add v1.2 nvdimm label definitions")
    b3fde74ea195 ("libnvdimm, label: add address abstraction identifiers")
    c12c48ce869d ("libnvdimm, label: add v1.2 interleave-set-cookie algorithm")
    f979b13c3cc5 ("libnvdimm, label: honor the lba size specified in v1.2 labels")
    faec6f8a1cd2 ("libnvdimm, label: populate the type_guid property for v1.2 namespaces")

v4.4.178: Failed to apply! Possible dependencies:
    0731de0dd95b ("libnvdimm, pfn: move 'memory mode' indication to sysfs")
    0bfb8dd3edd6 ("libnvdimm: cleanup nvdimm_namespace_common_probe(), kill 'host'")
    0caeef63e6d2 ("libnvdimm: Add a poison list and export badblocks")
    0e749e54244e ("dax: increase granularity of dax_clear_blocks() operations")
    2dc43331e34f ("libnvdimm, pfn: fix pfn seed creation")
    315c562536c4 ("libnvdimm, pfn: add 'align' attribute, default to HPAGE_SIZE")
    34c0fd540e79 ("mm, dax, pmem: introduce pfn_t")
    4b94ffdc4163 ("x86, mm: introduce vmem_altmap to augment vmemmap_populate()")
    52db400fcd50 ("pmem, dax: clean up clear_pmem()")
    87ba05dff351 ("libnvdimm: don't fail init for full badblocks list")
    9476df7d80df ("mm: introduce find_dev_pagemap()")
    9c41242817f4 ("libnvdimm: fix mode determination for e820 devices")
    ad9a8bde2cb1 ("libnvdimm, pmem: move definition of nvdimm_namespace_add_poison to nd.h")
    b2e0d1625e19 ("dax: fix lifetime of in-kernel dax mappings with dax_map_atomic()")
    b3fde74ea195 ("libnvdimm, label: add address abstraction identifiers")
    b95f5f4391fa ("libnvdimm: convert to statically allocated badblocks")
    bd032943b5b2 ("libnvdimm, pfn, convert nd_pfn_probe() to devm")
    c5ed9268643c ("libnvdimm, dax: autodetect support")
    cd03412a51ac ("libnvdimm, dax: introduce device-dax infrastructure")
    cfe30b872058 ("libnvdimm, pmem: adjust for section collisions with 'System RAM'")
    d2c0f041e1bb ("libnvdimm, pfn, pmem: allocate memmap array in persistent memory")
    d9cbe09d39aa ("libnvdimm, pmem: fix 'pfn' support for section-misaligned namespaces")
    f6ed58c70d14 ("libnvdimm, pfn: 'resource'-address and 'size' attributes for pfn devices")
    f7c6ab80fa5f ("libnvdimm, pfn: clean up pfn create parameters")


How should we proceed with this patch?

--
Thanks,
Sasha
