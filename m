Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 260252264A21C
 for <linux-nvdimm@lists.01.org>; Wed,  4 Apr 2018 07:28:51 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [RFC PATCH v4] ndctl: monitor: add ndctl monitor daemon
References: <20180313113308.2136-1-qi.fuli@jp.fujitsu.com>
 <CAPcyv4jPghKyQ6AuVJ-R=fiKcQufzHs-DExzcyHTbshF-2bq1Q@mail.gmail.com>
 <0DEDF3B159719A448A49EF0E7B11E3222764A26E@g01jpexmbkw01>
Date: Wed, 04 Apr 2018 10:28:49 -0400
In-Reply-To: <0DEDF3B159719A448A49EF0E7B11E3222764A26E@g01jpexmbkw01> (Fuli
 Qi's message of "Thu, 29 Mar 2018 10:02:27 +0000")
Message-ID: <x497epnnizi.fsf@segfault.boston.devel.redhat.com>
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
To: "Qi, Fuli" <qi.fuli@jp.fujitsu.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

"Qi, Fuli" <qi.fuli@jp.fujitsu.com> writes:

>> > In this implemention, when a ndctl monitor starts with [--daemon] option, all
>> > the arguments will be saved into a temp file named as daemon-name and placed
>> > under /etc/sysconfig/ndctl/ directory. The temp file would be used as an
>> > EnvironmentFile by systemd, and it would be deleted automatically when the
>> > systemd service is stopped.

IIRC, /etc/sysconfig is not present on non-Red Hat OSes.  Additionally,
for Red Hat OSes, /etc/sysconfig/<app>/ does not replace daemon
configuration files.

Cheers,
Jeff
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
