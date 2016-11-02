Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-lf0-x232.google.com (mail-lf0-x232.google.com
 [IPv6:2a00:1450:4010:c07::232])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DEB2481CE2
 for <linux-nvdimm@lists.01.org>; Wed,  2 Nov 2016 03:02:34 -0700 (PDT)
Received: by mail-lf0-x232.google.com with SMTP id b81so8099347lfe.1
 for <linux-nvdimm@lists.01.org>; Wed, 02 Nov 2016 03:02:36 -0700 (PDT)
Date: Wed, 2 Nov 2016 13:02:17 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH 0/21 v4] dax: Clear dirty bits after flushing caches
Message-ID: <20161102100217.GC20724@node.shutemov.name>
References: <1478039794-20253-1-git-send-email-jack@suse.cz>
 <20161101231318.GC20418@quack2.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20161101231318.GC20418@quack2.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: linux-nvdimm@lists.01.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Nov 02, 2016 at 12:13:18AM +0100, Jan Kara wrote:
> Hi,
> 
> forgot to add Kirill to CC since this modifies the fault path he changed
> recently. I don't want to resend the whole series just because of this so
> at least I'm pinging him like this...

I see strange mix x/20 and x/21 patches. Which should I look at?

-- 
 Kirill A. Shutemov
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
