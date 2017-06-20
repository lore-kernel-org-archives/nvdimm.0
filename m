Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2C74321BBC401
 for <linux-nvdimm@lists.01.org>; Tue, 20 Jun 2017 09:25:58 -0700 (PDT)
Received: from mail-ua0-f178.google.com (mail-ua0-f178.google.com
 [209.85.217.178])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id CFACA23A0B
 for <linux-nvdimm@lists.01.org>; Tue, 20 Jun 2017 16:27:20 +0000 (UTC)
Received: by mail-ua0-f178.google.com with SMTP id g40so86900563uaa.3
 for <linux-nvdimm@lists.01.org>; Tue, 20 Jun 2017 09:27:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPcyv4jkH6iwDoG4NnCaTNXozwYgVXiJDe2iFSONcE63KvGQoA@mail.gmail.com>
References: <149766213493.22552.4057048843646200083.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CALCETrU1Hg=q4cdQDex--3nVBfwRC1o=9pC6Ss77Z8Lxg7ZJLg@mail.gmail.com>
 <CAPcyv4j4UEegViDJcLZjVv5AFGC18-DcvHFnhZatB0hH3BY85g@mail.gmail.com>
 <CALCETrUfv26pvmyQ1gOkKbzfSXK2DnmeBG6VmSWjFy1WBhknTw@mail.gmail.com>
 <CAPcyv4iPb69e+rE3fJUzm9U_P_dLfhantU9mvYmV-R0oQee4rA@mail.gmail.com>
 <CALCETrVY38h2ajpod2U_2pdHSp8zO4mG2p19h=OnnHmhGTairw@mail.gmail.com>
 <20170619132107.GG11993@dastard>
 <CALCETrUe0igzK0RZTSSondkCY3ApYQti89tOh00f0j_APrf_dQ@mail.gmail.com>
 <20170620004653.GI17542@dastard>
 <CALCETrVuoPDRuuhc9X8eVCYiFUzWLSTRkcjbD6jas_2J2GixNQ@mail.gmail.com>
 <20170620084924.GA9752@lst.de>
 <CAPcyv4jkH6iwDoG4NnCaTNXozwYgVXiJDe2iFSONcE63KvGQoA@mail.gmail.com>
From: Andy Lutomirski <luto@kernel.org>
Date: Tue, 20 Jun 2017 09:26:59 -0700
Message-ID: <CALCETrVdOLTp1YYVwpsvWbZam2tgHnAxqERUP9c2CsbPGj+ARg@mail.gmail.com>
Subject: Re: [RFC PATCH 2/2] mm, fs: daxfile, an interface for
 byte-addressable updates to pmem
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux API <linux-api@vger.kernel.org>, Dave Chinner <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Andy Lutomirski <luto@kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jun 20, 2017 at 9:17 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Tue, Jun 20, 2017 at 1:49 AM, Christoph Hellwig <hch@lst.de> wrote:
>> [stripped giant fullquotes]
>>
>> On Mon, Jun 19, 2017 at 10:53:12PM -0700, Andy Lutomirski wrote:
>>> But that's my whole point.  The kernel doesn't really need to prevent
>>> all these background maintenance operations -- it just needs to block
>>> .page_mkwrite until they are synced.  I think that whatever new
>>> mechanism we add for this should be sticky, but I see no reason why
>>> the filesystem should have to block reflink on a DAX file entirely.
>>
>> Agreed - IFF we want to support write through semantics this is the
>> only somewhat feasible way.  It still has massive downsides of forcing
>> the full sync machinery to run from the page fauly handler, which
>> I'm rather scared off, but that's still better than creating a magic
>> special case that isn't managable at all.
>
> An immutable-extent DAX-file and a reflink-capable DAX-file are not
> mutually exclusive, and I have yet to hear a need for reflink support
> without fsync/msync. Instead I have heard the need for an immutable
> file for RDMA purposes, especially for hardware that can't trigger an
> mmu fault. The special management of an immutable file is acceptable
> to get these capabilities.

I guess this applies to any user of get_user_pages() on a DAX-mapped file.  Hmm.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
