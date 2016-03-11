Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ob0-x22d.google.com (mail-ob0-x22d.google.com
 [IPv6:2607:f8b0:4003:c01::22d])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BAF001A1E1E
 for <linux-nvdimm@lists.01.org>; Fri, 11 Mar 2016 13:40:36 -0800 (PST)
Received: by mail-ob0-x22d.google.com with SMTP id m7so125932694obh.3
 for <linux-nvdimm@lists.01.org>; Fri, 11 Mar 2016 13:40:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1457730784-9890-2-git-send-email-matthew.r.wilcox@intel.com>
References: <1457730784-9890-1-git-send-email-matthew.r.wilcox@intel.com>
 <1457730784-9890-2-git-send-email-matthew.r.wilcox@intel.com>
Date: Fri, 11 Mar 2016 13:40:20 -0800
Message-ID: <CAPcyv4g82US298_mCd75toj9kEeyDhw0cP_Ott0R8fOydWNsSg@mail.gmail.com>
Subject: Re: [PATCH 1/3] pfn_t: Change the encoding
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
To: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: Linux MM <linux-mm@kvack.org>, Dave Hansen <dave.hansen@linux.intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Mar 11, 2016 at 1:13 PM, Matthew Wilcox
<matthew.r.wilcox@intel.com> wrote:
> By moving the flag bits to the bottom, we encourage commonality
> between SGs with pages and those using pfn_t.  We can also then insert
> a pfn_t into a radix tree, as it uses the same two bits for indirect &
> exceptional indicators.

It's not immediately clear to me what we gain with SG entry
commonality.  The down side is that we lose the property that
pfn_to_pfn_t() is a nop.  This was Dave's suggestion so that the
nominal case did not change the binary layout of a typical pfn.

Can we just bit swizzle a pfn_t on insertion/retrieval from the radix?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
