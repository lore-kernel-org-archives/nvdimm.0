Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F1B93FC9
	for <nvdimm@lists.linux.dev>; Thu, 16 Sep 2021 23:54:30 +0000 (UTC)
Received: by mail-pf1-f176.google.com with SMTP id j6so7466865pfa.4
        for <nvdimm@lists.linux.dev>; Thu, 16 Sep 2021 16:54:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=twpAOha8nEogmwqVEa1jpZe4E/wearTU5rO2Em9RZNk=;
        b=WupkJEKr3//hG1sLZCByevTpoLhyz8VSlrqwigLyMmjny3zE5cnBuE8d+qZb/9C5Lg
         lsvD/m1uTH2KgDtDohLlKitQKtA2aEKPglrIVevXwD3tHh5lsah73J79i0/vmnAbBwbK
         tlK6TRjwneyq+uEs/nzK23lZy4w67yWbRd6oM1fkFlbk0RpVUDWq1c5ogsSN1A3HErX3
         uFZBcmzpS1yd6kJRziXjt05OxPhCTTKg8w+6FHJCPUJDCcA9g99zISUeftFGReO9xRs/
         2tg2n7HE8VXCFsSZTpEqTiDKwEJhccsBwvvspu6hCx5jQyvQCv9we0E8k4AQKLQyRaLo
         tqQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=twpAOha8nEogmwqVEa1jpZe4E/wearTU5rO2Em9RZNk=;
        b=QVzw7EZzmXzGCyFTqBVIahxm1oUoSxabyvlDMU/u+5lLk4dZlPmK/IEpCk85fY5Wg/
         MwYFrtCH6FD8zBVFJCn9ZXxMvcm9JP3eoO+MmLDLOx3M/7dTV+FzroLery06BlPWQgp6
         KF1GFezaKrmTK9ddG1hkXOb3Y//yhaFT5EeD+IdZRePcM27A+ck9EOfKlhD2LKXhhzxQ
         gjdFoUvYUiA+UCIB9/piHsPb4tv3+GJU5ZUArFUZqMk3gvnSP0tijJEpzC2inCkP2CdP
         Q4aIkzRIxb469T7sCKvyb4lTAAjo2vDrR+ss+tVZmn+uf+Pgd09OSwCjkXY4rjSyvv6Q
         DajQ==
X-Gm-Message-State: AOAM531YRxhmpZo3AZKTGSmLujWm6GwLUzVZuHgRPgu+4f3zvc44v6r1
	0W5VDPxGvQ44DqZazDMHmcmAsxJf8BYHwaDlP+vXBw==
X-Google-Smtp-Source: ABdhPJw5fX2UJGAJDwhqZKJKGZNuoUpKEqy8dbB8kVDN2FbStN3fIkzdAkcKucT+s7u5JF0AkRI+klvcvKeonmt9490=
X-Received: by 2002:a05:6a00:1a10:b0:412:448c:89ca with SMTP id
 g16-20020a056a001a1000b00412448c89camr7670861pfv.86.1631836469651; Thu, 16
 Sep 2021 16:54:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210831090459.2306727-1-vishal.l.verma@intel.com> <20210831090459.2306727-6-vishal.l.verma@intel.com>
In-Reply-To: <20210831090459.2306727-6-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 16 Sep 2021 16:54:18 -0700
Message-ID: <CAPcyv4jLQY0XMy=+3wLHv2PJ=ogFU12yuD2xj9RRjs+=H1jAUw@mail.gmail.com>
Subject: Re: [ndctl PATCH 5/7] util/parse-configs: add a key/value search helper
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, QI Fuli <qi.fuli@jp.fujitsu.com>, 
	"Hu, Fenghua" <fenghua.hu@intel.com>, QI Fuli <qi.fuli@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Aug 31, 2021 at 2:05 AM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> Add a new config query type called CONFIG_SEARCH_SECTION, which searches
> all loaded config files based on a query criteria of: specified section
> name, specified key/value pair within that section, and can return other
> key/values from the section that matched the search criteria.
>
> This allows for multiple named subsections, where a subsection name is
> of the type: '[section subsection]'.

Presumably in the future this could be used to search by subsection as
well, but for now daxctl does not need that and the subsection is
essentially a comment?

Perhaps that should be called out in a sample / comment only
daxctl.conf file that gets installed by default. Where it clarifies
that everything after the first whitespace in a section name is
treated as a subsection.

This looks good to me.
