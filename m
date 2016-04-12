Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-lf0-x230.google.com (mail-lf0-x230.google.com
 [IPv6:2a00:1450:4010:c07::230])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DB2FF1A21AE
 for <linux-nvdimm@lists.01.org>; Mon, 11 Apr 2016 17:30:26 -0700 (PDT)
Received: by mail-lf0-x230.google.com with SMTP id e190so3284438lfe.0
 for <linux-nvdimm@lists.01.org>; Mon, 11 Apr 2016 17:30:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160411235859.GD119165@tevye.fc.hp.com>
References: <cover.1458583367.git.jerry.hoemann@hpe.com>
 <a016b07e1705c6b37ae9aa4d0a1896e6b7eb6f75.1458583367.git.jerry.hoemann@hpe.com>
 <CAPcyv4jJ1muO8zZPa_5ZQxWKBCdiYrOM=40Bsw_yM54+tJL5Tw@mail.gmail.com>
 <20160411235859.GD119165@tevye.fc.hp.com>
Date: Mon, 11 Apr 2016 17:30:25 -0700
Message-ID: <CAPcyv4heEHXcKKHdek-=z4m_fjKOjaNLV+c-FRF5zHMSk+ckzw@mail.gmail.com>
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

On Mon, Apr 11, 2016 at 4:58 PM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
> On Mon, Apr 11, 2016 at 02:43:39PM -0700, Dan Williams wrote:
>> On Mon, Mar 21, 2016 at 12:37 PM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
>> > NVDIMM DSMs whose functions map to the Intel Example DSM, can
>> > be called with the ND_IOCTL_.* ioctl interface.  Those that
>> > don't map, can only be called with the pass thru command.
>> >
>> > Save this indication in struct nvdimm to be passed to
>> > the sysfs interface.
>> >
>>
>> I'm having trouble understanding the intent of cmd_ioctl.  I don't
>> want a flag for "supports Intel Example DSM", I want a mask of ND
>> commands the bus provider knows how to handle in its ->ndctl() entry
>> point for the given dimm.  The bus provider is free to provide a
>> translation of ND command to the bus specific command.  It's just an
>> arbitrary coincidence that the current list of ND commands matches the
>> Intel ACPI _DSM command format.
>
> This is my extension of your earlier RFC patch, so I may
> have misunderstood your original intent.
>
> The commands_show functions prints the listing of commands for that device.
> There is one version for root, and one version for non-root.
>
> For root commands, both dsm spec match on names and semantics, so no
> code works for both nvdimms types.
>
> But for non-root commands the names/semantics don't match. So, this
> is an attempt to show that on an NVDIMM-N,  only the pass thru command
> is supported.

Ah, ok.  Rather than telling the core about a dsm_mask and a cmd_ioctl
at nvdimm_create() time, it should just be passing the mask of generic
ND commands that the dimm supports.  For NVDIMM-N that mask will just
be (1 << 10) it's up to the nfit driver to manage any ND command to
ACPI _DSM command number translation.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
