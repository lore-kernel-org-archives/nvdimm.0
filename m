Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com
 [IPv6:2607:f8b0:4864:20::342])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DB0332116DA24
 for <linux-nvdimm@lists.01.org>; Fri, 12 Oct 2018 16:26:38 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id c32so13886173otb.8
 for <linux-nvdimm@lists.01.org>; Fri, 12 Oct 2018 16:26:38 -0700 (PDT)
MIME-Version: 1.0
References: <153937659078.70378.7857051533055879370.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <153937659078.70378.7857051533055879370.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 12 Oct 2018 16:26:25 -0700
Message-ID: <CAPcyv4jTqYi0uZtqc-XFg6T3aRted1cY-TpjfPba_CMywhCWoQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] misc patches for nvdimm security fixes
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

On Fri, Oct 12, 2018 at 1:39 PM Dave Jiang <dave.jiang@intel.com> wrote:
>
> v2:
> - Fix key perm flags and remove SET_ATTR. (Dan)
> - Fixup comment for key_update code block (Dan)
> - Use key_destroy() instead of key_invalidate+key_put (Dan)
> - Fix dev_warn() output for nvdimm_security_disable() (Dan)
> - Drop patch 3/5 (applied by Dan)
> - Add support for self verify the requested key before giving up and freeze
>   security. (Dan)
>
> ---
>
> Dave Jiang (4):
>       libnvdimm: fix updating of kernel key during nvdimm key update
>       libnvdimm: fix incorrect output when nvdimm disable failed
>       libnvdimm: remove code to pull user key when there's no kernel key
>       libnvdimm: address state where dimm is unlocked in preOS
>

These look good to me, applied.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
