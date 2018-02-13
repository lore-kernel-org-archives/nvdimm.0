Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x236.google.com (mail-ot0-x236.google.com
 [IPv6:2607:f8b0:4003:c0f::236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C061B21CF1CFA
 for <linux-nvdimm@lists.01.org>; Tue, 13 Feb 2018 10:59:54 -0800 (PST)
Received: by mail-ot0-x236.google.com with SMTP id q9so18248958oti.0
 for <linux-nvdimm@lists.01.org>; Tue, 13 Feb 2018 11:05:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <x49bmgslnjd.fsf@segfault.boston.devel.redhat.com>
References: <151854564280.33267.17991825626084554488.stgit@djiang5-desk3.ch.intel.com>
 <x49bmgslnjd.fsf@segfault.boston.devel.redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 13 Feb 2018 11:05:44 -0800
Message-ID: <CAPcyv4hFPt9VAiD7q60xtHncC1aYxNr82or4T2i-tsSUJyHSug@mail.gmail.com>
Subject: Re: [PATCH v2] ndctl: add option to list firmware information for a
 DIMM
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
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Feb 13, 2018 at 11:03 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Dave Jiang <dave.jiang@intel.com> writes:
>
>> Adding firmware output of firmware information when ndctl list -D -F is used.
>> Components displayed are current firmware version, updated firmware version,
>> and if a coldboot is required (firmware updated).
>
> So now I don't get any output if I run:
>
> ndctl list -DF
>
> on an NVDIMM-N system.  I would expect the list to at least work, but no
> firmware information to be provided.  Is that not what you would expect?

Right, "ndctl list -DF" should be equivalent to "ndctl list -D" on
DIMMs where ndctl does not know how to retrieve the firmware details.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
