Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C361521107832
 for <linux-nvdimm@lists.01.org>; Thu, 30 Aug 2018 12:47:37 -0700 (PDT)
Date: Thu, 30 Aug 2018 15:47:32 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Snapshot target and DAX-capable devices
In-Reply-To: <x494lfbabwi.fsf@segfault.boston.devel.redhat.com>
Message-ID: <alpine.LRH.2.02.1808301545200.30950@file01.intranet.prod.int.rdu2.redhat.com>
References: <20180827160744.GE4002@quack2.suse.cz>
 <e38303902267d2d8bae8b0c88da84a4ed668e9fb.camel@hpe.com>
 <20180828075025.GA17756@quack2.suse.cz> <20180828175630.GA1197@redhat.com>
 <20180830093028.GC1767@quack2.suse.cz> <20180830184907.GA14867@redhat.com>
 <x494lfbabwi.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
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
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>



On Thu, 30 Aug 2018, Jeff Moyer wrote:

> Mike Snitzer <snitzer@redhat.com> writes:
> 
> > Until we properly add DAX support to dm-snapshot I'm afraid we really do
> > need to tolerate this "regression".  Since reality is the original
> > support for snapshot of a DAX DM device never worked in a robust way.
> 
> Agreed.
> 
> -Jeff

You can't support dax on snapshot - if someone maps a block and the block 
needs to be moved, then what?

Mikulas
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
