import torch
import flask

model = torch.load('model.pth', weights_only = False)