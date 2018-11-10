Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com
 [IPv6:2607:f8b0:4864:20::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3707821959CB2
 for <linux-nvdimm@lists.01.org>; Fri,  9 Nov 2018 17:45:48 -0800 (PST)
Received: by mail-oi1-x244.google.com with SMTP id u130-v6so3073266oie.7
 for <linux-nvdimm@lists.01.org>; Fri, 09 Nov 2018 17:45:48 -0800 (PST)
MIME-Version: 1.0
References: <154180093865.70506.6858789591063128903.stgit@djiang5-desk3.ch.intel.com>
 <154180163666.70506.8805433934495072699.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <154180163666.70506.8805433934495072699.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 9 Nov 2018 17:45:36 -0800
Message-ID: <CAPcyv4ioJ_dznpb2kMAVk+KDq00ng4WMni8dWVYPnSFn84CnJg@mail.gmail.com>
Subject: Re: [PATCH 02/11] libnvdimm/security: change clear text nvdimm keys
 to encrypted keys
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Nov 9, 2018 at 2:13 PM Dave Jiang <dave.jiang@intel.com> wrote:
>
> In order to make nvdimm more secure, encrypted keys will be used instead of
> clear text keys. A master key will be created to seal encrypted nvdimm
> keys. The master key can be a trusted key generated from TPM 2.0 or a less
> secure user key.
>
> In the process of this conversion, the kernel cached key will be removed
> in order to simplify the verification process. The hardware will be used to
> verify the decrypted user payload directly.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  Documentation/nvdimm/security.txt |   29 ++-
>  drivers/nvdimm/dimm.c             |    3
>  drivers/nvdimm/dimm_devs.c        |    2
>  drivers/nvdimm/nd-core.h          |    3
>  drivers/nvdimm/nd.h               |    5 -
>  drivers/nvdimm/security.c         |  316 ++++++++++---------------------------
>  6 files changed, 108 insertions(+), 250 deletions(-)

Remove twice the amount of code that it adds and gains features /
security, nice!
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
