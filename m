Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95892C2F0
	for <nvdimm@lists.linux.dev>; Sat,  1 Jul 2023 15:51:49 +0000 (UTC)
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-2b69f958ef3so47934581fa.1
        for <nvdimm@lists.linux.dev>; Sat, 01 Jul 2023 08:51:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1688226707; x=1690818707;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7bnv2dUq8TcNFZhlGLeiiAGB3YUTNN/I5HHQH6Qnrpo=;
        b=Umdk+2TtzoCcA1fHuw0nOne6Efh0y1OZP9aKvJC+WM0mSuDRkhmEsfyhBQn1m0K7Ae
         2wM/34lsZJF+dN8qiryLOiBMKVVHlxHyEqoCDwgq7o9ms4y9Ci9sZXfzm2N++vsLqHW1
         GBI41wQB/uB9/IJI5TEmXShxVcrnWRWxQZfj8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688226707; x=1690818707;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7bnv2dUq8TcNFZhlGLeiiAGB3YUTNN/I5HHQH6Qnrpo=;
        b=YdfBEuivDmcC+c4h+BskqkoS2pudToeIslgviv3XvaYyk0I0QxoOMnKEYszWeoJPuq
         uK4OeeQz+vqodDDDjfAOenXbin6GYHjQuA8abKe8IRYNSnT8tIUaTSmx5ZfW/xo8b60I
         fFXEcdghODV6uMhAWKoxz4FFeAgSgOdpXyXrAyTItFBsoTNp3BXNgmdVUa37XsJmUhVq
         nanrf7j+zDHiv6CBVoaXcr6vu7RILcpZnsfID9MWcRPN0wWa9LpSgR5xO/J2Ti1d8Jve
         veDZEiUeQ6i2j1FA7EZ2bJcEFpdCmsM+zRnaHaCTcwCU2JDn0Edcrn5Rj37RZtAnRC4v
         rcKQ==
X-Gm-Message-State: ABy/qLbh9S7H7Wm+oBTmG69tLthQEY0BCKdQhp10UI96fAgNUaVpIQyP
	f4svenrgQO++L65Sh47HBeGKeBaAUTLZYsdDzEdCTNw7
X-Google-Smtp-Source: APBJJlFd0MJu+Z/zg5946ZJr/osr09zX1kSGulRiax2vivcQ/I0uUyfeCYWSsgtJ9B1dYxcYDtA3pg==
X-Received: by 2002:a2e:2c14:0:b0:2b6:b2a9:ff23 with SMTP id s20-20020a2e2c14000000b002b6b2a9ff23mr3641024ljs.52.1688226707136;
        Sat, 01 Jul 2023 08:51:47 -0700 (PDT)
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com. [209.85.167.53])
        by smtp.gmail.com with ESMTPSA id d9-20020a2e96c9000000b002b6988ca476sm3699858ljj.101.2023.07.01.08.51.46
        for <nvdimm@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Jul 2023 08:51:46 -0700 (PDT)
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-4f766777605so4752994e87.1
        for <nvdimm@lists.linux.dev>; Sat, 01 Jul 2023 08:51:46 -0700 (PDT)
X-Received: by 2002:a05:6512:3b9c:b0:4ec:9ef9:e3d with SMTP id
 g28-20020a0565123b9c00b004ec9ef90e3dmr5355258lfv.26.1688226706024; Sat, 01
 Jul 2023 08:51:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <b40d43f78d320324c7a65ec0f3162524a4781c4c.camel@intel.com>
In-Reply-To: <b40d43f78d320324c7a65ec0f3162524a4781c4c.camel@intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 1 Jul 2023 08:51:29 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjqW4JnbnFQ9BnTsw08WG=MrtyD_bY=4vy66KNSAUnYQA@mail.gmail.com>
Message-ID: <CAHk-=wjqW4JnbnFQ9BnTsw08WG=MrtyD_bY=4vy66KNSAUnYQA@mail.gmail.com>
Subject: Re: [GIT PULL] NVDIMM and DAX for 6.5
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>, 
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, 30 Jun 2023 at 12:17, Verma, Vishal L <vishal.l.verma@intel.com> wrote:
>
> On an operational note, as Dan handed off the branch to me for this cycle, we
> missed that the original few commits were inadvertently made on top of a few
> CXL commits that went in in the 6.4-rc cycle via the CXL tree.
>
> git-request-pull included these, and hence they appear in the shortlog and
> diffstat below, but the actual merge correctly identifies and skips over them.
> I kept it as it is to preserve the linux-next soak time, but if I should have
> done it differently, please let me know.

No, this was the right thing to do. Apart from a slightly odd choice
of base for this all, the pull looks perfectly normal.

Thanks,
                Linus
