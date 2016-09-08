Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-it0-x22a.google.com (mail-it0-x22a.google.com
 [IPv6:2607:f8b0:4001:c0b::22a])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BF6ED1A1E5F
 for <linux-nvdimm@lists.01.org>; Thu,  8 Sep 2016 11:44:53 -0700 (PDT)
Received: by mail-it0-x22a.google.com with SMTP id c198so97223686ith.1
 for <linux-nvdimm@lists.01.org>; Thu, 08 Sep 2016 11:44:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160908173654.31479-1-brian.boylston@hpe.com>
References: <20160908173654.31479-1-brian.boylston@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 8 Sep 2016 11:44:52 -0700
Message-ID: <CAPcyv4h_kZybhuGdZYuNsG81-YQqt6K1xpYeUboAGjKmrzBWXg@mail.gmail.com>
Subject: Re: [ndctl PATCH] util: fix dimm health alarm trip reporting
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
To: Brian Boylston <brian.boylston@hpe.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Sep 8, 2016 at 10:36 AM, Brian Boylston <brian.boylston@hpe.com> wrote:
> Use ndctl_cmd_smart_get_alarm_flags() instead of
> ndctl_cmd_smart_get_spares() to populate "alarm_temperature" and
> "alarm_spares".
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Brian Boylston <brian.boylston@hpe.com>

Thanks, applied.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
