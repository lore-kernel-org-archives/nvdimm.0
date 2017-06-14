Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 722F121A18AAA
 for <linux-nvdimm@lists.01.org>; Wed, 14 Jun 2017 10:10:48 -0700 (PDT)
Subject: Re: [PATCH v2 1/2] mm: improve readability of
 transparent_hugepage_enabled()
References: <149739530052.20686.9000645746376519779.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149739530612.20686.14760671150202647861.stgit@dwillia2-desk3.amr.corp.intel.com>
 <e944ba00-3139-8da0-a1f9-642be9300c7c@suse.cz>
 <CAPcyv4h2GfqK3o4WdrKuhKnmjWeXBjeCOCsMv4M-xg9PViLbFw@mail.gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Message-ID: <0dd98f27-59b4-4503-1479-45372c939d6b@suse.cz>
Date: Wed, 14 Jun 2017 19:11:23 +0200
MIME-Version: 1.0
In-Reply-To: <CAPcyv4h2GfqK3o4WdrKuhKnmjWeXBjeCOCsMv4M-xg9PViLbFw@mail.gmail.com>
Content-Language: en-US
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Christoph Hellwig <hch@lst.de>, Linux MM <linux-mm@kvack.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On 06/14/2017 07:02 PM, Dan Williams wrote:
> On Wed, Jun 14, 2017 at 9:53 AM, Vlastimil Babka <vbabka@suse.cz> wrote:
> 
> Can you share the test-thp.c so I can add this to my test collection?

Attached.

> I'm assuming cbmc is "Bounded Model Checker for C/C++"?

Yes. This blog from Paul inspired me:
http://paulmck.livejournal.com/38997.html

Works nicely, just if it finds a bug, the counterexamples are a bit of
PITA to decipher :)

Vlastimil
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
