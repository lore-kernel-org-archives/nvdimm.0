Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x22a.google.com (mail-ot0-x22a.google.com
 [IPv6:2607:f8b0:4003:c0f::22a])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9738221A6F106
 for <linux-nvdimm@lists.01.org>; Wed, 14 Jun 2017 10:01:21 -0700 (PDT)
Received: by mail-ot0-x22a.google.com with SMTP id r67so5073893ota.1
 for <linux-nvdimm@lists.01.org>; Wed, 14 Jun 2017 10:02:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <e944ba00-3139-8da0-a1f9-642be9300c7c@suse.cz>
References: <149739530052.20686.9000645746376519779.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149739530612.20686.14760671150202647861.stgit@dwillia2-desk3.amr.corp.intel.com>
 <e944ba00-3139-8da0-a1f9-642be9300c7c@suse.cz>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 14 Jun 2017 10:02:36 -0700
Message-ID: <CAPcyv4h2GfqK3o4WdrKuhKnmjWeXBjeCOCsMv4M-xg9PViLbFw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] mm: improve readability of
 transparent_hugepage_enabled()
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
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Christoph Hellwig <hch@lst.de>, Linux MM <linux-mm@kvack.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jun 14, 2017 at 9:53 AM, Vlastimil Babka <vbabka@suse.cz> wrote:
> On 06/14/2017 01:08 AM, Dan Williams wrote:
>> Turn the macro into a static inline and rewrite the condition checks for
>> better readability in preparation for adding another condition.
>>
>> Cc: Jan Kara <jack@suse.cz>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
>> [ross: fix logic to make conversion equivalent]
>> Acked-by: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>
> Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
>
> vbabka@gusiac:~/wrk/cbmc> cbmc test-thp.c
> CBMC version 5.3 64-bit x86_64 linux
> Parsing test-thp.c
> file <command-line> line 0: <command-line>:0:0: warning:
> "__STDC_VERSION__" redefined
> file <command-line> line 0: <built-in>: note: this is the location of
> the previous definition
> Converting
> Type-checking test-thp
> file test-thp.c line 75 function main: function `assert' is not declared
> Generating GOTO Program
> Adding CPROVER library
> Function Pointer Removal
> Partial Inlining
> Generic Property Instrumentation
> Starting Bounded Model Checking
> size of program expression: 171 steps
> simple slicing removed 3 assignments
> Generated 1 VCC(s), 1 remaining after simplification
> Passing problem to propositional reduction
> converting SSA
> Running propositional reduction
> Post-processing
> Solving with MiniSAT 2.2.0 with simplifier
> 4899 variables, 13228 clauses
> SAT checker: negated claim is UNSATISFIABLE, i.e., holds
> Runtime decision procedure: 0.008s
> VERIFICATION SUCCESSFUL
>
> (and yeah, the v1 version fails :)

Can you share the test-thp.c so I can add this to my test collection?
I'm assuming cbmc is "Bounded Model Checker for C/C++"?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
