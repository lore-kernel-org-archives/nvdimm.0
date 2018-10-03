Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com
 [IPv6:2607:f8b0:4864:20::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 78E9221144CFA
 for <linux-nvdimm@lists.01.org>; Wed,  3 Oct 2018 14:14:11 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id p125-v6so5767328oic.3
 for <linux-nvdimm@lists.01.org>; Wed, 03 Oct 2018 14:14:11 -0700 (PDT)
MIME-Version: 1.0
References: <20181002142959.GD9127@quack2.suse.cz>
 <20181002143713.GA19845@infradead.org>
 <20181002144412.GC4963@linux-x5ow.site> <20181002145206.GA10903@infradead.org>
 <20181002153100.GG9127@quack2.suse.cz>
 <CAPcyv4j0tTD+rENqFExA68aw=-MmtCBaOe1qJovyrmJC=yBg-Q@mail.gmail.com>
 <20181003125056.GA21043@quack2.suse.cz>
 <CAPcyv4jfV10yuTiPg6ijsPRRL2-c_48ovfpU5TK1Zu7BWnfk3g@mail.gmail.com>
 <20181003150658.GC24030@quack2.suse.cz>
 <CAPcyv4iJvN6_Cf6tw=5a=Uh99LfMFKU7n8QkGcz1ZaxL0Oi-3w@mail.gmail.com>
 <20181003164407.GK24030@quack2.suse.cz>
In-Reply-To: <20181003164407.GK24030@quack2.suse.cz>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 3 Oct 2018 14:13:59 -0700
Message-ID: <CAPcyv4iCXNYTSzwU5OoZc_b+xxbqKwjyQV74CRxEfvDjaMPDfg@mail.gmail.com>
Subject: Re: Problems with VM_MIXEDMAP removal from /proc/<pid>/smaps
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
Cc: linux-xfs <linux-xfs@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux API <linux-api@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Linux MM <linux-mm@kvack.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Oct 3, 2018 at 9:46 AM Jan Kara <jack@suse.cz> wrote:
>
> On Wed 03-10-18 08:13:37, Dan Williams wrote:
> > On Wed, Oct 3, 2018 at 8:07 AM Jan Kara <jack@suse.cz> wrote:
> > > WRT per-inode DAX property, AFAIU that inode flag is just going to be
> > > advisory thing - i.e., use DAX if possible. If you mount a filesystem with
> > > these inode flags set in a configuration which does not allow DAX to be
> > > used, you will still be able to access such inodes but the access will use
> > > page cache instead. And querying these flags should better show real
> > > on-disk status and not just whether DAX is used as that would result in an
> > > even bigger mess. So this feature seems to be somewhat orthogonal to the
> > > API I'm looking for.
> >
> > True, I imagine once we have that flag we will be able to distinguish
> > the "saved" property and the "effective / live" property of DAX...
> > Also it's really not DAX that applications care about as much as "is
> > there page-cache indirection / overhead for this mapping?". That seems
> > to be a narrower guarantee that we can make than what "DAX" might
> > imply.
>
> Right. So what do people think about my suggestion earlier in the thread to
> use madvise(MADV_DIRECT_ACCESS) for this? Currently it would return success
> when DAX is in use, failure otherwise. Later we could extend it to be also
> used as a hint for caching policy for the inode...

The only problem is that you can't use it purely as a query. If we
ever did plumb it to be a hint you could not read the state without
writing the state.

mincore(2) seems to be close the intent of discovering whether RAM is
being consumed for a given address range, but it currently is
implemented to only indicate if *any* mapping is established, not
whether RAM is consumed. I can see an argument that a dax mapped file
should always report an empty mincore vector.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
