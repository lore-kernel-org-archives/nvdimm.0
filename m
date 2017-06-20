Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22a.google.com (mail-oi0-x22a.google.com
 [IPv6:2607:f8b0:4003:c06::22a])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4EC1621BBC406
 for <linux-nvdimm@lists.01.org>; Tue, 20 Jun 2017 09:16:15 -0700 (PDT)
Received: by mail-oi0-x22a.google.com with SMTP id p66so42389402oia.0
 for <linux-nvdimm@lists.01.org>; Tue, 20 Jun 2017 09:17:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170620084924.GA9752@lst.de>
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
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 20 Jun 2017 09:17:36 -0700
Message-ID: <CAPcyv4jkH6iwDoG4NnCaTNXozwYgVXiJDe2iFSONcE63KvGQoA@mail.gmail.com>
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
To: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux API <linux-api@vger.kernel.org>, Dave Chinner <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Andy Lutomirski <luto@kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jun 20, 2017 at 1:49 AM, Christoph Hellwig <hch@lst.de> wrote:
> [stripped giant fullquotes]
>
> On Mon, Jun 19, 2017 at 10:53:12PM -0700, Andy Lutomirski wrote:
>> But that's my whole point.  The kernel doesn't really need to prevent
>> all these background maintenance operations -- it just needs to block
>> .page_mkwrite until they are synced.  I think that whatever new
>> mechanism we add for this should be sticky, but I see no reason why
>> the filesystem should have to block reflink on a DAX file entirely.
>
> Agreed - IFF we want to support write through semantics this is the
> only somewhat feasible way.  It still has massive downsides of forcing
> the full sync machinery to run from the page fauly handler, which
> I'm rather scared off, but that's still better than creating a magic
> special case that isn't managable at all.

An immutable-extent DAX-file and a reflink-capable DAX-file are not
mutually exclusive, and I have yet to hear a need for reflink support
without fsync/msync. Instead I have heard the need for an immutable
file for RDMA purposes, especially for hardware that can't trigger an
mmu fault. The special management of an immutable file is acceptable
to get these capabilities.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
