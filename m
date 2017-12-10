Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 56E142214E335
 for <linux-nvdimm@lists.01.org>; Sat,  9 Dec 2017 22:10:52 -0800 (PST)
Date: Sun, 10 Dec 2017 14:15:25 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [fstests PATCH v6 2/2] generic: add test for DAX MAP_SYNC support
Message-ID: <20171210061525.GK2749@eguan.usersys.redhat.com>
References: <20171207103657.GF2749@eguan.usersys.redhat.com>
 <20171207231950.9023-1-ross.zwisler@linux.intel.com>
 <20171208063610.GH2749@eguan.usersys.redhat.com>
 <20171208174747.GA4308@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20171208174747.GA4308@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, Amir Goldstein <amir73il@gmail.com>, Dave Chinner <david@fromorbit.com>, fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Dec 08, 2017 at 10:47:47AM -0700, Ross Zwisler wrote:
> On Fri, Dec 08, 2017 at 02:36:10PM +0800, Eryu Guan wrote:
> 
> > (Test was re-numbered as generic/470, BTW.)
> 
> Thanks!  For future reference, does the pattern of us submitting tests with
> high numbers (generic/999) to avoid merge conflicts and asking you to renumber
> them when you merge work for you?  Or would you prefer that we number our
> tests to the next available, which may change from submission to submission?

For patch that adds a single test, either way is fine, I need to edit
the patch anyway on conflicts, as the group file conflicts. For patch or
patchset that adds multiple tests, starting with a high test seq number
would be better, I only need to edit the group file by hand, not the seq
numbers in each test (that can be done by ./tools/mvtest script).

But overall, the starting seq number doesn't matter that much. OTOH,
basing new tests on top of latest master as much as possible would be
perfered, that reduces the possibility of conflicts, as I only need to
resolve conflicts within all the new tests.

Thanks,
Eryu
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
