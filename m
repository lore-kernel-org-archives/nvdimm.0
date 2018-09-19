Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com
 [IPv6:2607:f8b0:4864:20::342])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8E21621142FE2
 for <linux-nvdimm@lists.01.org>; Tue, 18 Sep 2018 17:57:58 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id u20-v6so3982624otk.10
 for <linux-nvdimm@lists.01.org>; Tue, 18 Sep 2018 17:57:58 -0700 (PDT)
MIME-Version: 1.0
References: <20180918234831.29197-1-vishal.l.verma@intel.com>
In-Reply-To: <20180918234831.29197-1-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 18 Sep 2018 17:57:42 -0700
Message-ID: <CAPcyv4i4HJUf0p7jNoXyhm1k3BPtqPvQWrpOeHLuAo2X1Gcb2g@mail.gmail.com>
Subject: Re: [PATCH v2] libnvdimm, pfn: during init, clear errors in the
 metadata area
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
To: Vishal L Verma <vishal.l.verma@intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Sep 18, 2018 at 4:49 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> If there are badblocks present in the 'struct page' area for pfn
> namespaces, until now, the only way to clear them has been to force the
> namespace into raw mode, clear the errors, and re-enable the fsdax mode.
> This is clunky, given that it should be easy enough for the pfn driver
> to do the same.
>
> Add a new helper that uses the most recently available badblocks list to
> check whether there are any badblocks that lie in the volatile struct
> page area. If so, before initializing the struct pages, send down
> targeted writes via nvdimm_write_bytes to write zeroes to the affected
> blocks, and thus clear errors.
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Looks good to me, will apply for 4.20.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
