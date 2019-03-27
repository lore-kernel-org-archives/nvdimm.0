From: Dexuan Cui <decui-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: RE: [ndctl PATCH v3 4/5] libndctl: Add a new dimm-op
 cmd_is_supported()
Date: Wed, 27 Mar 2019 17:05:35 +0000
Message-ID: <PU1P153MB01698AFABE15E285E1CE93E4BF580@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
References: <20190323042028.4310-1-decui@microsoft.com>
 <20190323042028.4310-5-decui@microsoft.com>
 <072e59f43a276b9daa93c131866fc26fabaad626.camel@intel.com>
 <PU1P153MB0169D3CF9E54018F22C5EB30BF5F0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <2e75cba1e02c5ed1701eaf397476a3256130e9b9.camel@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <2e75cba1e02c5ed1701eaf397476a3256130e9b9.camel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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
> Sent: Wednesday, March 27, 2019 9:17 AM
> To: Williams, Dan J <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; Dexuan Cui
> <decui-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>; Jiang, Dave <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>;
> linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org; dexuan.cui-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org; Michael Kelley
> <mikelley-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> Cc: jthumshirn-l3A5Bk7waGM@public.gmane.org; qi.fuli-LMvhtfratI1BDgjK7y7TUQ@public.gmane.org
> Subject: Re: [ndctl PATCH v3 4/5] libndctl: Add a new dimm-op
> cmd_is_supported()
> 
> 
> On Tue, 2019-03-26 at 23:29 +0000, Dexuan Cui wrote:
> 
> > Here ndctl is checking if ND_CMD_SMART is supported in
> > dimm->cmd_mask. For all the non-NVDIMM_FAMILY_INTEL families,
> > the check is false, including the HPE1 and MSFT families.
> >
> > So IMO we need this new dimm-ops to make "ndctl monitor" work
> > for Hyper-V. I think the other non-INTEL families can't work with
> > "ndctl monitor" either, but I don't have a hardward to test.
> >
> Ah ok makes sense - I think with that I don't have any other comments -
> I'll queue the patches for the pending branch.
> 
> Thanks,
> 	-Vishal

Great! Thanks you!

-- Dexuan
