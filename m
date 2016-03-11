Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22b.google.com (mail-oi0-x22b.google.com
 [IPv6:2607:f8b0:4003:c06::22b])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 760C91A1F7B
 for <linux-nvdimm@lists.01.org>; Fri, 11 Mar 2016 10:28:44 -0800 (PST)
Received: by mail-oi0-x22b.google.com with SMTP id d205so92097336oia.0
 for <linux-nvdimm@lists.01.org>; Fri, 11 Mar 2016 10:28:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1457685810-4103-1-git-send-email-jthumshirn@suse.de>
References: <1457685810-4103-1-git-send-email-jthumshirn@suse.de>
Date: Fri, 11 Mar 2016 10:28:27 -0800
Message-ID: <CAPcyv4hde7eGwyiFYWnybbrgxUBkGJGhZYFnFMx1xOYQPnPsvw@mail.gmail.com>
Subject: Re: [ndctl PATCH v2] ndctl: Grab kernel version from utsname()
From: Dan Williams <dan.j.williams@intel.com>
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
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Mar 11, 2016 at 12:43 AM, Johannes Thumshirn <jthumshirn@suse.de> wrote:
> Grab the kernel version used for tests dynamically via utsname() instead of
> hardcoding the version of the build host.
>
> Otherwise tests will be skipped if the build host had a too old kernel
> version.
>
> flodin:~ # ./ndctl test
> __ndctl_test_attempt: skip test_libndctl:1950 requires: 4.2.0 current: 4.1.0
> test-libndctl: SKIP
> __ndctl_test_attempt: skip test_dpa_alloc:300 requires: 4.2.0 current: 4.1.0
> test-dpa-alloc: SKIP
> __ndctl_test_attempt: skip test_parent_uuid:230 requires: 4.3.0 current: 4.1.0
> test-parent-uuid: SKIP
> attempted: 3 skipped: 3
>
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  test/core.c |   15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
>
>  Changes to v1:
>  Use utsname.release which is obviously correct.
>  On my test system utsname.release = "4.4.4-default"
>
>  I can only imagine the sscanf() failing and on stack garbage in a, b, c being
>  greater than KERNEL_VERSION(4, 3, 0).

Looks good to me, applied for v52.  I've pushed it out on the
'pending' branch.  It will move to 'master' after the v4.6-rc1 kernel
is released.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
