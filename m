Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x244.google.com (mail-oi0-x244.google.com
 [IPv6:2607:f8b0:4003:c06::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2930C20985980
 for <linux-nvdimm@lists.01.org>; Fri, 13 Jul 2018 16:05:50 -0700 (PDT)
Received: by mail-oi0-x244.google.com with SMTP id d189-v6so65070884oib.6
 for <linux-nvdimm@lists.01.org>; Fri, 13 Jul 2018 16:05:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <153142851854.27297.8356860633862959932.stgit@djiang5-desk3.ch.intel.com>
References: <153142840572.27297.8070233763007198738.stgit@djiang5-desk3.ch.intel.com>
 <153142851854.27297.8356860633862959932.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 13 Jul 2018 16:05:49 -0700
Message-ID: <CAPcyv4i=N+4Rx3zKOYxrwjPXeKfp5NCT+E+sY8NxGoUVJ83Dgw@mail.gmail.com>
Subject: Re: [PATCH v4 02/11] libnvdimm: create keyring to store security keys
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
Cc: David Howells <dhowells@redhat.com>, "Schofield, Alison  <alison.schofield@intel.com>, keyrings@vger.kernel.org, Kees Cook" <keescook@chromium.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jul 12, 2018 at 1:48 PM, Dave Jiang <dave.jiang@intel.com> wrote:
> Prepping the libnvdimm to support security management by adding a keyring
> in order to provide passphrase management through the kernel key management
> APIs.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  drivers/nvdimm/core.c      |    7 +++
>  drivers/nvdimm/dimm_devs.c |   96 ++++++++++++++++++++++++++++++++++++++++++++
>  drivers/nvdimm/nd-core.h   |    1
>  include/linux/libnvdimm.h  |    5 ++
>  4 files changed, 107 insertions(+), 2 deletions(-)
>

Looks good to me,

You can add:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
