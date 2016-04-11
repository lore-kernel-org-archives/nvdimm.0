Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x235.google.com (mail-oi0-x235.google.com
 [IPv6:2607:f8b0:4003:c06::235])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 650331A21E2
 for <linux-nvdimm@lists.01.org>; Mon, 11 Apr 2016 14:43:40 -0700 (PDT)
Received: by mail-oi0-x235.google.com with SMTP id w85so225155194oiw.0
 for <linux-nvdimm@lists.01.org>; Mon, 11 Apr 2016 14:43:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <a016b07e1705c6b37ae9aa4d0a1896e6b7eb6f75.1458583367.git.jerry.hoemann@hpe.com>
References: <cover.1458583367.git.jerry.hoemann@hpe.com>
 <a016b07e1705c6b37ae9aa4d0a1896e6b7eb6f75.1458583367.git.jerry.hoemann@hpe.com>
Date: Mon, 11 Apr 2016 14:43:39 -0700
Message-ID: <CAPcyv4jJ1muO8zZPa_5ZQxWKBCdiYrOM=40Bsw_yM54+tJL5Tw@mail.gmail.com>
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
To: Jerry Hoemann <jerry.hoemann@hpe.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Mar 21, 2016 at 12:37 PM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
> NVDIMM DSMs whose functions map to the Intel Example DSM, can
> be called with the ND_IOCTL_.* ioctl interface.  Those that
> don't map, can only be called with the pass thru command.
>
> Save this indication in struct nvdimm to be passed to
> the sysfs interface.
>

I'm having trouble understanding the intent of cmd_ioctl.  I don't
want a flag for "supports Intel Example DSM", I want a mask of ND
commands the bus provider knows how to handle in its ->ndctl() entry
point for the given dimm.  The bus provider is free to provide a
translation of ND command to the bus specific command.  It's just an
arbitrary coincidence that the current list of ND commands matches the
Intel ACPI _DSM command format.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
