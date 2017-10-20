Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22e.google.com (mail-oi0-x22e.google.com
 [IPv6:2607:f8b0:4003:c06::22e])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6241720347146
 for <linux-nvdimm@lists.01.org>; Thu, 19 Oct 2017 17:01:15 -0700 (PDT)
Received: by mail-oi0-x22e.google.com with SMTP id v9so17647177oif.13
 for <linux-nvdimm@lists.01.org>; Thu, 19 Oct 2017 17:04:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4bdb8de6-72ab-8b21-56e9-97903875ea24@oracle.com>
References: <efdf3c01-b91b-4b69-33a8-90cbccfe803d@oracle.com>
 <x494lquhl3k.fsf@segfault.boston.devel.redhat.com>
 <CAA9_cmc+rM_+=tFXw1dYqyuZdiV7KstmBG6aOku+4CBmk6++iw@mail.gmail.com>
 <4bdb8de6-72ab-8b21-56e9-97903875ea24@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 19 Oct 2017 17:04:52 -0700
Message-ID: <CAPcyv4hO=7Z8qkMf1vRoN9=3-DCHJc8FicrXua1yxZ-a=4RApg@mail.gmail.com>
Subject: Re: what happened to byte-addressable read()/write() to character
 device DAX?
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
To: jane.chu@oracle.com
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Oct 19, 2017 at 4:59 PM, <jane.chu@oracle.com> wrote:
[..]
> Thank you both for the clarification!
> Is there documents that elaborate the new resolve in detail?

This might answer some of your questions: https://lwn.net/Articles/731706/
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
