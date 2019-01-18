From: Sasha Levin <sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] libnvdimm/label: Clear 'updating' flag after label-set
 update
Date: Fri, 18 Jan 2019 15:01:47 +0000
Message-ID: <20190118150148.3D34D20896@mail.kernel.org>
References: <154758319127.1865528.486579211628557163.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <154758319127.1865528.486579211628557163.stgit-p8uTFz9XbKj2zm6wflaqv1nYeNYlB/vhral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kelly Couch <kelly.j.couch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

Hi,

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag,
fixing commit: f524bf271a5c libnvdimm: write pmem label set.

The bot has tested the following trees: v4.20.2, v4.19.15, v4.14.93, v4.9.150, v4.4.170.

v4.20.2: Build OK!
v4.19.15: Build OK!
v4.14.93: Build OK!
v4.9.150: Build OK!
v4.4.170: Failed to apply! Possible dependencies:
    0caeef63e6d2 ("libnvdimm: Add a poison list and export badblocks")
    16660eaea0cc ("libnvdimm, namespace: update label implementation for multi-pmem")
    1cf03c00e7c1 ("nfit: scrub and register regions in a workqueue")
    31eca76ba2fc ("nfit, libnvdimm: limited/whitelisted dimm command marshaling mechanism")
    44c462eb9e19 ("libnvdimm, region: move region-mapping input-paramters to nd_mapping_desc")
    4577b0665515 ("nfit: update address range scrub commands to the acpi 6.1 format")
    6e2452dff444 ("nfit: Continue init even if ARS commands are unimplemented")
    747ffe11b440 ("libnvdimm, tools/testing/nvdimm: fix 'ars_status' output buffer sizing")
    7ae0fa439faf ("nfit, libnvdimm: async region scrub workqueue")
    a61fe6f7902e ("nfit, tools/testing/nvdimm: unify common init for acpi_nfit_desc")
    ad9ac5e19575 ("nfit: always associate flush hints")
    ae8219f186d8 ("libnvdimm, label: convert label tracking to a linked list")
    aef253382266 ("libnvdimm, nfit: centralize command status translation")
    d26f73f083ed ("nfit_test: Enable DSMs for all test NFITs")
    e3654eca70d6 ("nfit, libnvdimm: clarify "commands" vs "_DSMs"")
    e5ae3b252c67 ("libnvdimm, nfit: move flush hint mapping to region-device driver-data")


How should we proceed with this patch?

--
Thanks,
Sasha
