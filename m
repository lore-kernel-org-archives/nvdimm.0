Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com
 [IPv6:2607:f8b0:4864:20::342])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9F0D721B02822
 for <linux-nvdimm@lists.01.org>; Thu, 31 Jan 2019 16:37:11 -0800 (PST)
Received: by mail-ot1-x342.google.com with SMTP id a11so4550542otr.10
 for <linux-nvdimm@lists.01.org>; Thu, 31 Jan 2019 16:37:11 -0800 (PST)
MIME-Version: 1.0
References: <154897708013.51182.14455795448108189661.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <154897708013.51182.14455795448108189661.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 31 Jan 2019 16:36:58 -0800
Message-ID: <CAPcyv4jJ_d3jmT+2vQBeWzrF7yoAiH2atxRBHiFXfZ0EJKfoqQ@mail.gmail.com>
Subject: Re: [PATCH] ndctl: security documentation update
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
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jan 31, 2019 at 3:25 PM Dave Jiang <dave.jiang@intel.com> wrote:
>
> In order to avoid terminology confusion, update the security man pages so
> that when we are talking about keys, we are exclusively talking about the
> key encryption key. The encrypted keys with payload will be referred to as
> passphrase instead.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  Documentation/ndctl/intel-nvdimm-security.txt   |   14 +++++++-------
>  Documentation/ndctl/ndctl-freeze-security.txt   |    4 ++++
>  Documentation/ndctl/ndctl-remove-passphrase.txt |   10 +++++++---
>  Documentation/ndctl/ndctl-sanitize-dimm.txt     |    6 +++++-
>  Documentation/ndctl/ndctl-setup-passphrase.txt  |   16 ++++++++--------
>  Documentation/ndctl/ndctl-update-passphrase.txt |   17 ++++++++---------
>  6 files changed, 39 insertions(+), 28 deletions(-)

This reads much better to me, thanks for fixups.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
