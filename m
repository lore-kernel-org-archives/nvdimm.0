From: Dexuan Cui <decui-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: RE: [ndctl PATCH v3 4/5] libndctl: Add a new dimm-op
 cmd_is_supported()
Date: Tue, 26 Mar 2019 23:29:00 +0000
Message-ID: <PU1P153MB0169D3CF9E54018F22C5EB30BF5F0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
References: <20190323042028.4310-1-decui@microsoft.com>
 <20190323042028.4310-5-decui@microsoft.com>
 <072e59f43a276b9daa93c131866fc26fabaad626.camel@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <072e59f43a276b9daa93c131866fc26fabaad626.camel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: "Verma, Vishal L" <vishal.l.verma-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Williams, Dan J" <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, "dexuan.cui-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <dexuan.cui-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michael Kelley <mikelley-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Cc: "qi.fuli-LMvhtfratI1BDgjK7y7TUQ@public.gmane.org" <qi.fuli-LMvhtfratI1BDgjK7y7TUQ@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

> From: Verma, Vishal L <vishal.l.verma-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Sent: Tuesday, March 26, 2019 2:56 PM
> 
> Hi Dexuan,
> 
> Thanks for making the changes, this revision /mostly/ looks good to me
> except -
> 
> The kernel dsm mask just seems to be hard-coded in [1]

Yes, the kernel basically hard-codes the dsm_mask to 0x1F for Hyper-V,
but the kernel doesn't export the dsm_mask to the userspace; instead,
the kernel exports the "nvdimm->cmd_mask" to the userspace: see
drivers/nvdimm/dimm_devs.c: commands_show().

The cmd_mask is initialized in acpi_nfit_register_dimms(), and it's not
1:1 mapped to the dsm_mask for non-NVDIMM_FAMILY_INTEL families:
see acpi_nfit_register_dimms().
 
> So is there any reason that that can't simply be allowed to advertise
> "everything is supported", similar to what the MSFT family does, and
> that should remove the need for playing games with dimm-ops (i.e. now
> there is another layer that can affect command support detection).

Here ndctl is checking if ND_CMD_SMART is supported in
dimm->cmd_mask. For all the non-NVDIMM_FAMILY_INTEL families,
the check is false, including the HPE1 and MSFT families.

So IMO we need this new dimm-ops to make "ndctl monitor" work
for Hyper-V. I think the other non-INTEL families can't work with
"ndctl monitor" either, but I don't have a hardward to test.

Thanks,
-- Dexuan
