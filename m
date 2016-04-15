Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ob0-x231.google.com (mail-ob0-x231.google.com
 [IPv6:2607:f8b0:4003:c01::231])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8FFD61A1FB4
 for <linux-nvdimm@lists.01.org>; Thu, 14 Apr 2016 19:49:57 -0700 (PDT)
Received: by mail-ob0-x231.google.com with SMTP id bg3so58143138obb.1
 for <linux-nvdimm@lists.01.org>; Thu, 14 Apr 2016 19:49:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160414225829.GA95107@tevye.fc.hp.com>
References: <cover.1458583367.git.jerry.hoemann@hpe.com>
 <a016b07e1705c6b37ae9aa4d0a1896e6b7eb6f75.1458583367.git.jerry.hoemann@hpe.com>
 <CAPcyv4jJ1muO8zZPa_5ZQxWKBCdiYrOM=40Bsw_yM54+tJL5Tw@mail.gmail.com>
 <20160411235859.GD119165@tevye.fc.hp.com>
 <CAPcyv4heEHXcKKHdek-=z4m_fjKOjaNLV+c-FRF5zHMSk+ckzw@mail.gmail.com>
 <20160412214156.GA72655@tevye.fc.hp.com>
 <CAPcyv4iQ4VBnXnbqF7BF=7DbEjVeHbY0FNmU=Gaf_K4hepVDFA@mail.gmail.com>
 <20160414225829.GA95107@tevye.fc.hp.com>
Date: Thu, 14 Apr 2016 19:49:56 -0700
Message-ID: <CAPcyv4h9Jv6Zq2mBKjjYX8+CEr3MfR3QB3Lnwi6jfgqN0ACxLQ@mail.gmail.com>
Subject: Re: [PATCH v8 09/10] nvdimm: sysfs shows which dsm support full
 command ioctl.
From: Dan Williams <dan.j.williams@intel.com>
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
To: Jerry Hoemann <Jerry.Hoemann@hpe.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Apr 14, 2016 at 3:58 PM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
> On Tue, Apr 12, 2016 at 03:05:47PM -0700, Dan Williams wrote:
[..]
>> I was thinking that the dsm_mask cease being a pointer in struct
>> nvdimm and instead be a cmd_mask (of ND function numbers).  struct
>> nfit_mem would maintain the dsm_mask.  acpi_nfit_ctl is charged with
>> translating from the nd command to the acpi dsm.  This "just works"
>> for the existing sysfs interface, and we can export the dsm_mask in
>> the nfit-specific attributes of the nme device.
>
> Not sure I understand.
>
> Are you suggesting that struct nfit_mem have both a dsm_mask and a cmd_mask
> and when nvdimm_create is called we pass just cmd_mask and assign it to
> new field u64 cmd_mask (deleting the old pointer to dsm_mask?)

Yes.

> For NVDIMM-N,  the cmd_mask would just be (1<<ND_CMD_CALL) and for the
> pre-existent nvdimm it would be (1<<ND_CMD_CALL)|dsm_mask
>

Yes.

> This would have acpi_nfit_ctl testing against cmd_mask and __nd_ioctl
> testing against dsm_mask.

__nd_ioctl would only test against cmd_mask.

acpi_nfit_ctl would check if it can translate the cmd to a DSM.  In
the case of ND_CMD_SMART..ND_CMD_VENDOR it translate to the
corresponding DSM (currently a nop for Intel DIMMs and not applicable
to HP DIMMs).  In the case of ND_CMD_CALL it will check the nfit_mem's
dsm_mask to see if the DSM is supported and passes it through.

> I don't know how nvdimm_create would get the nd_cmd_mask if its
> not determined in acpi_nfit_add_dimm when we determine uuid......

nfit_mem will have a cmd_mask and dsm_mask both initialized at
acpi_nfit_add_dimm() time.  At nvdimm_create we just pass
nfit_mem->cmd_mask.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
