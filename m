From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: fix dax_dev NULL dereference
Date: Tue, 30 Jul 2019 15:07:38 -0400
Message-ID: <20190730190737.GA14873@redhat.com>
References: <20190730113708.14660-1-pagupta@redhat.com>
 <2030283543.5419072.1564486701158.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2030283543.5419072.1564486701158.JavaMail.zimbra@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Pankaj Gupta <pagupta@redhat.com>
Cc: dan j williams <dan.j.williams@intel.com>, dm-devel@redhat.com, linux-nvdimm@lists.01.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, agk@redhat.com, jencce.kernel@gmail.com
List-Id: linux-nvdimm@lists.01.org

I staged the fix (which I tweaked) here:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.3&id=95b9ebb78c4c733f8912a195fbd0bc19960e726e

Also, please note this additional related commit that just serves to
improve a related function name and clean up some whitespace:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.3&id=f965f935a89bb174fd3f6d6b51bba91c1ed258c5

I'll likely send these to Linus for 5.2-rc3 later this week.

Thanks,
Mike
