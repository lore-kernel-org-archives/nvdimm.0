From: Sasha Levin <sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] acpi/nfit: Fix command-supported detection
Date: Wed, 16 Jan 2019 13:35:42 +0000
Message-ID: <20190116133543.25AF220675@mail.kernel.org>
References: <154725096972.1367907.12968253382302127133.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <154725096972.1367907.12968253382302127133.stgit-p8uTFz9XbKj2zm6wflaqv1nYeNYlB/vhral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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
Cc: Sujith Pandel <sujith_pandel-8PEkshWhKlo@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

Hi,

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag,
fixing commit: 31eca76ba2fc nfit, libnvdimm: limited/whitelisted dimm command marshaling mechanism.

The bot has tested the following trees: v4.20.2, v4.19.15, v4.14.93, v4.9.150.

v4.20.2: Failed to apply! Possible dependencies:
    b3ed2ce024c3 ("acpi/nfit: Add support for Intel DSM 1.8 commands")

v4.19.15: Failed to apply! Possible dependencies:
    0ead11181fe0 ("acpi, nfit: Collect shutdown status")
    6f07f86c4940 ("acpi, nfit: Introduce nfit_mem flags")
    b3ed2ce024c3 ("acpi/nfit: Add support for Intel DSM 1.8 commands")

v4.14.93: Build OK!
v4.9.150: Failed to apply! Possible dependencies:
    0f817ae696b0 ("usb: dwc3: pci: add a private driver structure")
    11e142701609 ("acpi, nfit: add support for NVDIMM_FAMILY_INTEL v1.6 DSMs")
    23222f8f8dce ("acpi, nfit: Add function to look up nvdimm device and provide SMBIOS handle")
    36daf3aa399c ("usb: dwc3: pci: avoid build warning")
    3f23df72dc35 ("mmc: sdhci-pci: Use ACPI to get max frequency for Intel NI byt sdio")
    41c8bdb3ab10 ("acpi, nfit: Switch to use new generic UUID API")
    42237e393f64 ("libnvdimm: allow a platform to force enable label support")
    42b06496407c ("mmc: sdhci-pci: Add PCI ID for Intel NI byt sdio")
    4b27db7e26cd ("acpi, nfit: add support for the _LSI, _LSR, and _LSW label methods")
    8f078b38dd38 ("libnvdimm: convert NDD_ flags to use bitops, introduce NDD_LOCKED")
    94116f8126de ("ACPI: Switch to use generic guid_t in acpi_evaluate_dsm()")
    9cecca75b5a0 ("usb: dwc3: pci: call _DSM for suspend/resume")
    9d62ed965118 ("libnvdimm: handle locked label storage areas")
    b3ed2ce024c3 ("acpi/nfit: Add support for Intel DSM 1.8 commands")
    b7fe92999a98 ("ACPI / extlog: Switch to use new generic UUID API")
    b917078c1c10 ("net: hns: Add ACPI support to check SFP present")
    c959a6b00ff5 ("mmc: sdhci-pci: Don't re-tune with runtime pm for some Intel devices")
    d2061f9cc32d ("usb: typec: add driver for Intel Whiskey Cove PMIC USB Type-C PHY")
    fab9288428ec ("usb: USB Type-C connector class")


How should we proceed with this patch?

--
Thanks,
Sasha
