Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B57029CA
	for <nvdimm@lists.linux.dev>; Thu, 16 Dec 2021 22:44:53 +0000 (UTC)
Received: by mail-pj1-f46.google.com with SMTP id f18-20020a17090aa79200b001ad9cb23022so776636pjq.4
        for <nvdimm@lists.linux.dev>; Thu, 16 Dec 2021 14:44:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wjBHnTjTkDhBIv9aSNWyKBwTrDAQAco39WFiqHZTknQ=;
        b=14dcoCDwTM23G1egrWIXeWjUeAxaJsHdffkusd155UmwdTxnarAYGVJHY7GokUKTK3
         rLhZl+17TlwPMeu8T8Acldk2od8W3kUFlChNpGHF4NSddYOm9t67JGRX2MnEPUO8dZui
         0bsHjCPE8Rmeej5/bFWsD1BFML5ld7RLKGLiQvlJgnHiOCaz+D1H+Oxx1ciNlpgZZamd
         H2TRXNxJEqGPJOttSq+Pa9BccPTBNIApoI13CFVzKRKkSdEdMJrrAHLoVsGsZ9GCHfNu
         kDD2wgtGod1hUdhmFlpcvxqyg1ncrKkT+cvkp3hDmqIdkFA8LILLfHQ9VAXIBmi2FovH
         LKGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wjBHnTjTkDhBIv9aSNWyKBwTrDAQAco39WFiqHZTknQ=;
        b=nsoqpM3f15MsEjXCzxK/tTjnus0Lr7P98I/q1QZv0anAWQpchous+VFqsq4uYXOJvg
         e73y/vctXNFtQYbA4a5XSIgfs/yehip9QPG0K9PNcb1XRwnBjjRxQGeMO8WgagUWj2ko
         SftULAYzhdry+QA3L16qOEBJJouTHM4TutDeTK+syw2PT9K/8n298x87goCs/ZcJdLda
         8inmapleHUfgxnIp8MdMTI3iYqERguDuD5rUixL31jYhGUUnHBCsSjLxRZNvI2OeFLuJ
         JXLMESKJ1/K893gV/i7IqZ9xem0c0wUtnyD4xAp6A82gqD8nYk55G1C0NbSFnS465Hx+
         Kd7w==
X-Gm-Message-State: AOAM532vsPZxnUW2qFOGWgn32DhIU3cInm+r6PJuCdUkh6hmNDozudT3
	eq3vHXJT092fHUHd4ZjRSkNOZXKJtn4OCT/vFeJxsA==
X-Google-Smtp-Source: ABdhPJwWxtln+qZ8IiZYLpC+uKjkH9OWJ3QgHuU0Uv1G2Y+1KqozfZsQvHilGzjhZnVw/4nAOhAXQcSRiRAcgqyfUjI=
X-Received: by 2002:a17:903:41c1:b0:141:f28f:729e with SMTP id
 u1-20020a17090341c100b00141f28f729emr367476ple.34.1639694692917; Thu, 16 Dec
 2021 14:44:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211210223440.3946603-1-vishal.l.verma@intel.com> <20211210223440.3946603-9-vishal.l.verma@intel.com>
In-Reply-To: <20211210223440.3946603-9-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 16 Dec 2021 14:44:43 -0800
Message-ID: <CAPcyv4iLRcs7=Y-tdWzkKa1LJzLyOgASoBe_Rz--SdEsOyUdbg@mail.gmail.com>
Subject: Re: [ndctl PATCH v3 08/11] util/parse-configs: add a key/value search helper
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, QI Fuli <qi.fuli@jp.fujitsu.com>, 
	"Hu, Fenghua" <fenghua.hu@intel.com>, QI Fuli <qi.fuli@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, Dec 10, 2021 at 2:34 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> Add a new config query type called CONFIG_SEARCH_SECTION, which searches
> all loaded config files based on a query criteria of: specified section
> name, specified key/value pair within that section, and can return other
> key/values from the section that matched the search criteria.
>
> This allows for multiple named subsections, where a subsection name is
> of the type: '[section subsection]'.

LGTM

Reviewed-by: Dan Wiilliams <dan.j.williams@intel.com>
