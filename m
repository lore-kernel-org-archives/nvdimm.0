Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AEA7F212E13C8
 for <linux-nvdimm@lists.01.org>; Tue, 30 Jul 2019 20:53:07 -0700 (PDT)
Date: Tue, 30 Jul 2019 23:50:36 -0400 (EDT)
From: Pankaj Gupta <pagupta@redhat.com>
Message-ID: <1887039269.5822356.1564545036201.JavaMail.zimbra@redhat.com>
In-Reply-To: <20190730190737.GA14873@redhat.com>
References: <20190730113708.14660-1-pagupta@redhat.com>
 <2030283543.5419072.1564486701158.JavaMail.zimbra@redhat.com>
 <20190730190737.GA14873@redhat.com>
Subject: Re: dm: fix dax_dev NULL dereference
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
To: Mike Snitzer <snitzer@redhat.com>
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, agk@redhat.com
List-ID: <linux-nvdimm@lists.01.org>


> 
> I staged the fix (which I tweaked) here:
> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.3&id=95b9ebb78c4c733f8912a195fbd0bc19960e726e
> 
> Also, please note this additional related commit that just serves to
> improve a related function name and clean up some whitespace:
> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.3&id=f965f935a89bb174fd3f6d6b51bba91c1ed258c5
> 
> I'll likely send these to Linus for 5.2-rc3 later this week.

o.k

Thank you,
Pankaj

> 
> Thanks,
> Mike
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
