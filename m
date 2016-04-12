Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22a.google.com (mail-oi0-x22a.google.com
 [IPv6:2607:f8b0:4003:c06::22a])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CAD1F1A2046
 for <linux-nvdimm@lists.01.org>; Tue, 12 Apr 2016 15:05:48 -0700 (PDT)
Received: by mail-oi0-x22a.google.com with SMTP id s79so40265851oie.1
 for <linux-nvdimm@lists.01.org>; Tue, 12 Apr 2016 15:05:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160412214156.GA72655@tevye.fc.hp.com>
References: <cover.1458583367.git.jerry.hoemann@hpe.com>
 <a016b07e1705c6b37ae9aa4d0a1896e6b7eb6f75.1458583367.git.jerry.hoemann@hpe.com>
 <CAPcyv4jJ1muO8zZPa_5ZQxWKBCdiYrOM=40Bsw_yM54+tJL5Tw@mail.gmail.com>
 <20160411235859.GD119165@tevye.fc.hp.com>
 <CAPcyv4heEHXcKKHdek-=z4m_fjKOjaNLV+c-FRF5zHMSk+ckzw@mail.gmail.com>
 <20160412214156.GA72655@tevye.fc.hp.com>
Date: Tue, 12 Apr 2016 15:05:47 -0700
Message-ID: <CAPcyv4iQ4VBnXnbqF7BF=7DbEjVeHbY0FNmU=Gaf_K4hepVDFA@mail.gmail.com>
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

On Tue, Apr 12, 2016 at 2:41 PM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
> On Mon, Apr 11, 2016 at 05:30:25PM -0700, Dan Williams wrote:
>> On Mon, Apr 11, 2016 at 4:58 PM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
>> > On Mon, Apr 11, 2016 at 02:43:39PM -0700, Dan Williams wrote:
>> >> On Mon, Mar 21, 2016 at 12:37 PM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
>> >> > NVDIMM DSMs whose functions map to the Intel Example DSM, can
>> >> > be called with the ND_IOCTL_.* ioctl interface.  Those that
>> >> > don't map, can only be called with the pass thru command.
>> >> >
>> >> > Save this indication in struct nvdimm to be passed to
>> >> > the sysfs interface.
>> >> >
>> >>
>> >> I'm having trouble understanding the intent of cmd_ioctl.  I don't
>> >> want a flag for "supports Intel Example DSM", I want a mask of ND
>> >> commands the bus provider knows how to handle in its ->ndctl() entry
>> >> point for the given dimm.  The bus provider is free to provide a
>> >> translation of ND command to the bus specific command.  It's just an
>> >> arbitrary coincidence that the current list of ND commands matches the
>> >> Intel ACPI _DSM command format.
>> >
>> > This is my extension of your earlier RFC patch, so I may
>> > have misunderstood your original intent.
>> >
>> > The commands_show functions prints the listing of commands for that device.
>> > There is one version for root, and one version for non-root.
>> >
>> > For root commands, both dsm spec match on names and semantics, so no
>> > code works for both nvdimms types.
>> >
>> > But for non-root commands the names/semantics don't match. So, this
>> > is an attempt to show that on an NVDIMM-N,  only the pass thru command
>> > is supported.
>>
>> Ah, ok.  Rather than telling the core about a dsm_mask and a cmd_ioctl
>> at nvdimm_create() time, it should just be passing the mask of generic
>> ND commands that the dimm supports.  For NVDIMM-N that mask will just
>> be (1 << 10) it's up to the nfit driver to manage any ND command to
>> ACPI _DSM command number translation.
>
> dsm_mask is used in both acpi_nfit_ctl and __nd_ioctl to filter calls
> the functions might make.  I think dsm_mask and cmd_ioctl need to be
> kept separate, or drop use of filtering by dsm_mask in these two
> functions.
>
> Or another way of controlling what commands_show produces?

I was thinking that the dsm_mask cease being a pointer in struct
nvdimm and instead be a cmd_mask (of ND function numbers).  struct
nfit_mem would maintain the dsm_mask.  acpi_nfit_ctl is charged with
translating from the nd command to the acpi dsm.  This "just works"
for the existing sysfs interface, and we can export the dsm_mask in
the nfit-specific attributes of the nme device.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
