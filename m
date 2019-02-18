From: Sasha Levin <sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/7] libnvdimm/pmem: Honor force_raw for legacy pmem
 regions
Date: Mon, 18 Feb 2019 21:14:34 +0000
Message-ID: <20190218211435.2E2572147A@mail.kernel.org>
References: <155000669130.348031.13764885263577554365.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <155000669130.348031.13764885263577554365.stgit-p8uTFz9XbKj2zm6wflaqv1nYeNYlB/vhral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

Hi,

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag,
fixing commit: 004f1afbe199 libnvdimm, pmem: direct map legacy pmem by default.

The bot has tested the following trees: v4.20.8, v4.19.21, v4.14.99, v4.9.156, v4.4.174.

v4.20.8: Build OK!
v4.19.21: Build OK!
v4.14.99: Build OK!
v4.9.156: Build OK!
v4.4.174: Failed to apply! Possible dependencies:
    0caeef63e6d2 ("libnvdimm: Add a poison list and export badblocks")
    0e749e54244e ("dax: increase granularity of dax_clear_blocks() operations")
    34c0fd540e79 ("mm, dax, pmem: introduce pfn_t")
    4b94ffdc4163 ("x86, mm: introduce vmem_altmap to augment vmemmap_populate()")
    52db400fcd50 ("pmem, dax: clean up clear_pmem()")
    87ba05dff351 ("libnvdimm: don't fail init for full badblocks list")
    9476df7d80df ("mm: introduce find_dev_pagemap()")
    ad9a8bde2cb1 ("libnvdimm, pmem: move definition of nvdimm_namespace_add_poison to nd.h")
    b2e0d1625e19 ("dax: fix lifetime of in-kernel dax mappings with dax_map_atomic()")
    b95f5f4391fa ("libnvdimm: convert to statically allocated badblocks")
    cfe30b872058 ("libnvdimm, pmem: adjust for section collisions with 'System RAM'")
    d2c0f041e1bb ("libnvdimm, pfn, pmem: allocate memmap array in persistent memory")
    d9cbe09d39aa ("libnvdimm, pmem: fix 'pfn' support for section-misaligned namespaces")


How should we proceed with this patch?

--
Thanks,
Sasha
