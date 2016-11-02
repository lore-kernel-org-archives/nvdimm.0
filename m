Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-lf0-x22e.google.com (mail-lf0-x22e.google.com
 [IPv6:2a00:1450:4010:c07::22e])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EEDC281D34
 for <linux-nvdimm@lists.01.org>; Wed,  2 Nov 2016 03:02:33 -0700 (PDT)
Received: by mail-lf0-x22e.google.com with SMTP id b14so8067090lfg.2
 for <linux-nvdimm@lists.01.org>; Wed, 02 Nov 2016 03:02:35 -0700 (PDT)
Date: Wed, 2 Nov 2016 12:58:48 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH 01/21] mm: Join struct fault_env and vm_fault
Message-ID: <20161102095848.GB20724@node.shutemov.name>
References: <1478039794-20253-1-git-send-email-jack@suse.cz>
 <1478039794-20253-3-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1478039794-20253-3-git-send-email-jack@suse.cz>
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
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Nov 01, 2016 at 11:36:08PM +0100, Jan Kara wrote:
> Currently we have two different structures for passing fault information
> around - struct vm_fault and struct fault_env. DAX will need more
> information in struct vm_fault to handle its faults so the content of
> that structure would become event closer to fault_env. Furthermore it
> would need to generate struct fault_env to be able to call some of the
> generic functions. So at this point I don't think there's much use in
> keeping these two structures separate. Just embed into struct vm_fault
> all that is needed to use it for both purposes.

What about just reference fault_env from vm_fault? We don't always need
vm_fault where we nee fault_env. It may save space on stack for some
codepaths.

-- 
 Kirill A. Shutemov
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
