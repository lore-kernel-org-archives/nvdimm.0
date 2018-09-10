Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2354.austin.hpe.com (g2t2354.austin.hpe.com [15.233.44.27])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 71EB5211158EE
 for <linux-nvdimm@lists.01.org>; Mon, 10 Sep 2018 07:21:55 -0700 (PDT)
From: "Kani, Toshi" <toshi.kani@hpe.com>
Subject: Re: open sets ext4_da_aops for DAX existing files
Date: Mon, 10 Sep 2018 14:21:52 +0000
Message-ID: <bd07c88ae9626ea1a66fb100113296d9d4033988.camel@hpe.com>
References: <76e07643e9c36e4273588bd3e7f29d1393de4c3d.camel@hpe.com>
 <x49zhwpfr6n.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49zhwpfr6n.fsf@segfault.boston.devel.redhat.com>
Content-Language: en-US
Content-ID: <01BE476D32E5F74F85742159204B99DE@NAMPRD84.PROD.OUTLOOK.COM>
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
To: "jmoyer@redhat.com" <jmoyer@redhat.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, 2018-09-10 at 08:54 -0400, Jeff Moyer wrote:
> "Kani, Toshi" <toshi.kani@hpe.com> writes:
> 
> > I noticed that both ext4_da_aops and ext4_dax_aops are used on DAX
> > mounted ext4 files.  Looking at open() path:
> 
> Eek.  How did you notice this?

I tested sync path on DAX files to see if it flushes processor cache
properly. Then I noticed that it sometimes does, but sometimes doesn't.
Looking into function traces, I realized that ext4_dax_writepages() and
ext4_writepages() are called depending on their file status.

-Toshi

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
