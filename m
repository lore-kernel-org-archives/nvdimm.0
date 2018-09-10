Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A6D2721B02822
 for <linux-nvdimm@lists.01.org>; Mon, 10 Sep 2018 05:54:57 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: open sets ext4_da_aops for DAX existing files
References: <76e07643e9c36e4273588bd3e7f29d1393de4c3d.camel@hpe.com>
Date: Mon, 10 Sep 2018 08:54:56 -0400
In-Reply-To: <76e07643e9c36e4273588bd3e7f29d1393de4c3d.camel@hpe.com> (Toshi
 Kani's message of "Fri, 7 Sep 2018 21:23:19 +0000")
Message-ID: <x49zhwpfr6n.fsf@segfault.boston.devel.redhat.com>
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
To: "Kani, Toshi" <toshi.kani@hpe.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

"Kani, Toshi" <toshi.kani@hpe.com> writes:

> I noticed that both ext4_da_aops and ext4_dax_aops are used on DAX
> mounted ext4 files.  Looking at open() path:

Eek.  How did you notice this?

-Jeff
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
