Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-it0-x232.google.com (mail-it0-x232.google.com
 [IPv6:2607:f8b0:4001:c0b::232])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 06B4F21A6F107
 for <linux-nvdimm@lists.01.org>; Tue,  2 May 2017 09:13:19 -0700 (PDT)
Received: by mail-it0-x232.google.com with SMTP id x188so16734556itb.0
 for <linux-nvdimm@lists.01.org>; Tue, 02 May 2017 09:13:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49995374.2635027.1493721837868.JavaMail.zimbra@redhat.com>
References: <0193aa84-a6ad-8472-43de-a49ea8617fc4@redhat.com>
 <149356211395.12803.4163197195995720592.stgit@dwillia2-desk3.amr.corp.intel.com>
 <49995374.2635027.1493721837868.JavaMail.zimbra@redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 2 May 2017 09:13:17 -0700
Message-ID: <CAPcyv4iyei+WBcdA5xCACX7jF_+TgRA9kYDVNmibuv7v4=kjCg@mail.gmail.com>
Subject: Re: [PATCH] device-dax: fix sysfs attribute deadlock
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
To: Yi Zhang <yizhan@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, May 2, 2017 at 3:43 AM, Yi Zhang <yizhan@redhat.com> wrote:
> Verified this patch on 4.11.
>
> Tested-by: Yi Zhang <yizhan@redhat.com>

Thanks!
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
