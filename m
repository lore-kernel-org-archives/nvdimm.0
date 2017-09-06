Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22e.google.com (mail-oi0-x22e.google.com
 [IPv6:2607:f8b0:4003:c06::22e])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AE7DB21E11D39
 for <linux-nvdimm@lists.01.org>; Tue,  5 Sep 2017 17:04:40 -0700 (PDT)
Received: by mail-oi0-x22e.google.com with SMTP id n18so33675884oig.2
 for <linux-nvdimm@lists.01.org>; Tue, 05 Sep 2017 17:07:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5C2C4439-D825-4651-9D1C-FF990DAFC398@fb.com>
References: <0DEDF3B159719A448A49EF0E7B11E3222756C8BF@g01jpexmbkw01>
 <CAPcyv4gO+L5RTi2+RL+YzS4uQF3bdSAOuxDD1to3_g8Quj4G7w@mail.gmail.com>
 <CAPcyv4jw9vsoGY1Mto6+yJChvgeT4Fkkz=4dE1kW34LDQR_65A@mail.gmail.com>
 <1131391F-F14B-48F8-9416-037FF0DF2128@fb.com>
 <CAPcyv4jLP9=3Sgd-cgh8+1YA+gfg8K1oZ4mAwmoEcprfrbAEMw@mail.gmail.com>
 <5C2C4439-D825-4651-9D1C-FF990DAFC398@fb.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 5 Sep 2017 17:07:28 -0700
Message-ID: <CAPcyv4j5eg39S4Fic8DytPPNe0btaCJKSvHrS17CwKQWqM3uBg@mail.gmail.com>
Subject: Re: [RFC patch 0/4]ndctl: nvdimmd: notify/monitor the feathers of
 over threshold event
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
To: Song Liu <songliubraving@fb.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Sep 5, 2017 at 5:02 PM, Song Liu <songliubraving@fb.com> wrote:

> For that, I would say generating JSON format is a solid building block. In
> my
> setup, I have use Scribe https://en.wikipedia.org/wiki/Scribe_(log_server)
> .
> And further processing of data happens after that. But I don't think
> Scribe is
> available everywhere.
>
> Besides SCSI events, JSON format is preferable by many users of my tools.
>
> Some system admins prefer to pull data on their preferred schedule
> (instead of
> having a daemon to push data to them). So being able to filter events by
> time
> could be a useful feature.
>
> I hope these are helpful.
>

Yes, definitely. Thanks Song!
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
